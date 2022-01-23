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

class FirebaseData: NSObject, ObservableObject {
    static var shared = FirebaseData()
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
//    var ref: DatabaseReference!
    var user: Users!
    let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    @Published var users: Users!
    @Published var places = [PlaceModel]()
    @Published var userAll = [Users]()
    @Published var deviseToken: String?
    @Published var arrayFavorit = [PlaceModel]()
    @Published var ref: DatabaseReference!
    @Published var stringArray = [String]()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super .init()
        self.getUserAll()
        self.fetchData()
        self.deviseToken = self.downUserData()
    }
    
  
   
    func fetchData() {
        ref = Database.database().reference(withPath: "user")
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
        
        getUserData(user: user) { [weak self] resalt in
            switch resalt {
                
            case .success(let myUser):
                self?.users = myUser
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
                if placeModel.switchPlace == "Приватно" && self?.user.uid != placeModel.userId {} else {
                                       
                    array.append(placeModel)
                }
            }
            self?.places = array
        }
        
       
        
    }
    func examenationDeviseTocen() {
        for place in places {
            if place.userId == user.uid {
                if place.deviseToken != deviseToken {
                    guard let newToken = deviseToken, let ref = ref else {return}
                    FirebaseAuthDatabase.updateToken(key: place.key, switchPlace: place.switchPlace, userId: user.uid, phoneNumber: user.phoneNumber ?? "", newToken: newToken, ref: ref)
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
                print("____________________________________________________________\(error.localizedDescription)")
            }
            var array = [Users]()
            for item in resalt!.documents {
                let user = Users(document: item)
                array.append(user!)
            }
            self?.userAll = array
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
                        print(document.documentID)
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
}
