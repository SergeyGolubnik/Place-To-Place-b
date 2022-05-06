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
    
    var firestoreLisenerBedjBig: ListenerRegistration?
    var firestoreLisenerBedg: ListenerRegistration?
    init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        self.ref = Database.database().reference(withPath: "user")
        
        fetchData()
        deviseToken = self.downUserData()
    }
    
    func fetchData() {
        
        guard let currentUser = auth.currentUser else {return}
        users = Users(user: currentUser)
        
        getUserData(user: users) { [weak self] resalt in
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
                
                if self?.users.uid != "swjITaC8zPZ5rjdML7LZftuaZCi1" {
                    
                    if placeModel.moderation ?? true {
                        if placeModel.switchPlace == "Приватно" && self?.users.uid != placeModel.userId {
                            if let placePhone = placeModel.phoneNumberArray {
                                if placePhone.contains(self?.users.phoneNumber ?? "") {
                                    array.append(placeModel)
                                    
                                }
                            }
                        } else {
                            
                            array.append(placeModel)
                        }
                    } else if self?.users.uid == placeModel.userId {
                        array.append(placeModel)
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
            if place.userId == users.uid {
                if place.deviseToken != deviseToken {
                    guard let newToken = deviseToken, let ref = ref else {return}
                    FirebaseAuthDatabase.updateToken(key: place.key, switchPlace: place.switchPlace, userId: users.uid, nikNamePlace: users.lastName ?? "", avatarNikPlace: users.avatarsURL ?? ""
                                                     , phoneNumber: users.phoneNumber ?? "", newToken: newToken, ref: ref)
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
                completion(.success(muser))
                self?.users = muser
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    func getUserDataBedjRecient(user: Users, completion: @escaping (Result<Int, Error>) -> Void) {
        firestoreLisenerBedg?.remove()
        firestoreLisenerBedjBig?.remove()
        firestoreLisenerBedg = db.collection("recent_message").document(user.uid).collection("messages").addSnapshotListener {(resalt, error) in
            if error != nil {
                completion(.failure(UserError.cannotGetUserInfo))
            }
            if let document = resalt {
                print("FirebaseData getUserDataBedjRecient  \(document)")
                var summBedj = 0
                var recientMessage = [RecentMessage]()
                resalt?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    recientMessage.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
                for i in recientMessage {
                    summBedj += i.bedj
                }
                print("FirebaseData getUserDataBedjRecient \(summBedj)")
                print("FirebaseData getUserDataBedjRecient \(user.bandel)")
                    self.firestore.collection("users").document(user.uid).updateData([
                        "bandel": summBedj
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        self.firestoreLisenerBedg = self.db.collection("users").document(user.uid)
                            .addSnapshotListener { documentSnapshot, error in
                                guard let document = documentSnapshot else {
                                    print("Error fetching document: \(error!)")
                                    completion(.failure(error!))
                                    return
                                }
                                let usersMy = Users(document: document)
                                completion(.success(usersMy?.bandel ?? 0))
                                    
                                
                                UIApplication.shared.applicationIconBadgeNumber = usersMy?.bandel ?? 0
                            }
                    }
            }
            completion(.failure(UserError.cannotGetUserInfo))
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
            guard let document = resalt else {return}
            for item in document.documents {
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
    
    func getDocument(){
        db.collection("users").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let userData = Users(snapshot: document.data() as NSDictionary)
                    if self?.users.uid == userData.uid {
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
            print(error.localizedDescription)
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
        if contacts == [] {
            return
        }
        print("getContact________________________________________\(contacts)")
        for cont in contacts {
            
            con.append(PhoneContact(contact: cont))
        }
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

