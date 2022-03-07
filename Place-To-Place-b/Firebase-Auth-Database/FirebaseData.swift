//
//  FirebaseData.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import Foundation
import Firebase
import UIKit
import SwiftUI
import FirebaseFirestore
import Contacts

class FirebaseData: ObservableObject {
    static var shared = FirebaseData()
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let ref: DatabaseReference!
    //    var ref: DatabaseReference!
    var user: Users!
    @Published var myUser: Users!
    let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    @Published var users: Users!
    @Published var places = [PlaceModel]()
    @Published var userAll = [Users]()
    @Published var deviseToken: String?
    @Published var arrayFavorit = [PlaceModel]()
    @Published var stringArray = [String]()
    @Published var phoneContact = [PhoneContact]()
    @Published var userPhoneAll = [String]()
    @Published var contactArrayAppPlace = [PhoneContact]()
    @Published var contactArrayAppPlaceNoApp = [PhoneContact]()
    
    init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        self.ref = Database.database().reference(withPath: "user")
        
        fetchData()
        deviseToken = self.downUserData()
    }
    
    
    
    func fetchData() {
        
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
        
        getUserData(user: user) { [weak self] resalt in
            switch resalt {
                
            case .success(let myUser):
                print("FirebaseData_____________________\(myUser)")
                self?.myUser = myUser
                self?.favoritFilter()
                self?.getDocument()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        ref.observe(.value) { [weak self] (snapshot) in
            var array = [PlaceModel]()
            for item in snapshot.children {
                let placeModel = PlaceModel(snapshot: item as! DataSnapshot)
                if placeModel.switchPlace == "Приватно" && self?.user.uid != placeModel.userId {
                    if let placePhone = placeModel.phoneNumberArray {
                        if placePhone.contains(self?.user.phoneNumber ?? "") {
                            array.append(placeModel)
                        }
                    }
                } else {
                    
                    array.append(placeModel)
                }
            }
            self?.places = array.sorted(by: {$0.date! > $1.date!})
        }
        
        self.getUserAll()
        
    }
    func examenationDeviseTocen() {
        for place in places {
            if place.userId == user.uid {
                if place.deviseToken != deviseToken {
                    guard let newToken = deviseToken, let ref = ref else {return}
                    FirebaseAuthDatabase.updateToken(key: place.key, switchPlace: place.switchPlace, userId: user.uid, nikNamePlace: user.lastName ?? "", avatarNikPlace: user.avatarsURL ?? ""
                                                     , phoneNumber: user.phoneNumber ?? "", newToken: newToken, ref: ref)
                }
            }
            
        }
    }
    func getUserData(user: Users, completion: @escaping (Result<Users, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                guard let muser = Users(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToUser))
                    return
                }
                self?.users = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    func getFrendUserData(userId: String, completion: @escaping (Result<Users, Error>) -> Void) {
        let docRef = usersRef.document(userId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = Users(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToUser))
                    return
                }
                
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    func getUserAll() {
        
        db.collection("users").getDocuments() {[weak self] (resalt, error) in
            
            if let error = error {
                print("FirebaseData____________________________________________________________\(error.localizedDescription)")
            }
            var phoneAll = [String]()
            var array = [Users]()
            for item in resalt!.documents {
                let user = Users(document: item)
                array.append(user!)
                phoneAll.append(user?.phoneNumber ?? "")
            }
            self?.userAll = array
            self?.userPhoneAll = phoneAll
            self?.vremPhone()
//            self?.getContact()
        }
    }
    func favoritFilter() {
        
        for item in self.places {
            if item.favorit != nil {
                for i in item.favorit! {
                    if i == self.users.uid {
                        arrayFavorit.append(item)
                    }
                }
            }
        }
    }
    func userData(token: String?) {
        guard let token = token else {return}
        UserDefaults.standard.set(token, forKey: "tokenUser")
    }
    func downUserData() -> String {
        guard let token = UserDefaults.standard.string(forKey: "tokenUser") else {return ""}
        self.deviseToken = token
        return token
    }
    
    func getImageUIImage(url: String) -> UIImage {
        
        let defaultImage = UIImage(named: "place-to-place-banner")
        
        let imageUrlString = url

        guard let imageUrl = URL(string: imageUrlString) else {return defaultImage!}
        do {
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)!
        } catch {
            print(error.localizedDescription)
            return defaultImage!
        }
        
    }
    
    func getDocument(){
        db.collection("users").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userData = Users(snapshot: document.data() as NSDictionary)
                    if self?.user.uid == userData.uid {
                        if self?.deviseToken != userData.deviseToken {
                            self?.db.collection("users").document(document.documentID).updateData([
                                "deviseToken": (self?.deviseToken)! as String
                            ]) { (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    
    func vremPhone() {
        self.phoneContact = [
            PhoneContact(name: "Anna", avatarData: nil, phoneNumber: ["+11111111111", "+22222222222", "+223456789"]),
            PhoneContact(name: "Boris", avatarData: nil, phoneNumber: ["+423456789","+22222222222"]),
            PhoneContact(name: "Владимир", avatarData: nil, phoneNumber: ["+79163603209", "+123456789"]),
            PhoneContact(name: "Геннадий", avatarData: nil, phoneNumber: ["+7123123"]),
            PhoneContact(name: "Дмитрий", avatarData: nil, phoneNumber: []),
            PhoneContact(name: "Евгений", avatarData: nil, phoneNumber: ["+7123123000000"]),
            PhoneContact(name: "Женя", avatarData: nil, phoneNumber: ["+7123120003", "+123450006789", "+22222222222"]),
            PhoneContact(name: "Зина", avatarData: nil, phoneNumber: ["+7120003123", "+123456789"]),
            PhoneContact(name: "Ирина", avatarData: nil, phoneNumber: ["+712310023", "+123400056789"])
        ]
        var arrayPhoneContact = [PhoneContact]()
        for userData in self.userPhoneAll {
            for phoneContact in self.phoneContact {
                if phoneContact.phoneNumber.contains(userData) {
                    arrayPhoneContact.append(phoneContact)

                }
            }
        }
        self.contactArrayAppPlace = Array(Set(arrayPhoneContact.sorted { $0.name ?? "" < $1.name ?? ""}))
        self.contactArrayAppPlaceNoApp = phoneContact.filter { !contactArrayAppPlace.contains($0) } .sorted { $0.name ?? "" < $1.name ?? ""}
    }
    
    func getContacts() -> [CNContact]? { //  ContactsFilter is Enum find it below

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
    func getContact() {
        var con = [PhoneContact]()
        guard let contacts = getContacts() else {return}
        for cont in contacts {

            con.append(PhoneContact(contact: cont))
        }
        print(con[0].phoneNumber)
        self.phoneContact = Array(Set(con.sorted { $0.name ?? "" < $1.name ?? ""}))
        var arrayPhoneContact = [PhoneContact]()
        for userData in self.userPhoneAll {
            for phoneContact in self.phoneContact {
                if phoneContact.phoneNumber.contains(userData) {
                    arrayPhoneContact.append(phoneContact)

                }
            }
        }
        self.contactArrayAppPlace = arrayPhoneContact.sorted { $0.name ?? "" < $1.name ?? ""}
        self.contactArrayAppPlaceNoApp = phoneContact.filter { !contactArrayAppPlace.contains($0) } .sorted { $0.name ?? "" < $1.name ?? ""}
    }

    
}

class PhoneContact: NSObject, Identifiable {
    
    var id = UUID()
    var name: String?
    var avatarData: Data?
    var image: Image?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        if let avatarData = avatarData {
            image       = Image(uiImage: UIImage(data: avatarData)!)
        }
        for phone in contact.phoneNumbers {
            var number = ""
            var numberArray = [Character]()
            for i in phone.value.stringValue {
                if i != "+", i != " ", i != ")", i != "(", i != "-" {
                    numberArray.append(i)
                }
            }
            if numberArray[0] == "8"{
                numberArray[0] = "7"
            } else if numberArray.count < 11 {
                
            }
            for i in numberArray {
                number += String(i)
                
            }
            phoneNumber.append("+\(number)")
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    init(name: String?, avatarData: Data?, phoneNumber: [String] ) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.avatarData = avatarData
    }
    
    override init() {
        super.init()
    }
}

