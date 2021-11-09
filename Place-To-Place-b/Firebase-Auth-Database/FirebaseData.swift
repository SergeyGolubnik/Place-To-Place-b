//
//  FirebaseData.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import Foundation
import Firebase

class FirebaseData: ObservableObject {
    
    static var shared = FirebaseData()
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
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        ref = Database.database().reference(withPath: "user")
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
        
        
        ref.observe(.value) { [weak self] (snapshot) in
            var array = [PlaceModel]()
            for item in snapshot.children {
                let placeModel = PlaceModel(snapshot: item as! DataSnapshot)
                if placeModel.switchPlace == "Приватно" && self?.user.uid != placeModel.userId {} else {
                    //                    if placeModel.userId == self?.user.uid {
                    //                        if self?.userToken != "", placeModel.deviseToken != self?.userToken, self?.userToken != nil {
                    //                            guard let userUid = self?.user.uid else {return}
                    //                            UserLoginRegister.updateToken(key: placeModel.key, switchPlace: placeModel.switchPlace, userId: userUid, newToken: (self?.userToken)!, ref: (self?.ref)!)
                    //                            array.append(placeModel)
                    //                        }
                    //                    }
                    array.append(placeModel)
                }
            }
            
            self?.places = array
        }
        
        getUserData(user: user) { resalt in
            switch resalt {
                
            case .success(let myUser):
                self.users = myUser
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        favoritFilter()
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
        
        db.collection("users").getDocuments() { [weak self] (resalt, error) in
            
            if let error = error {
                print("____________________________________________________________\(error.localizedDescription)")
            }
            var array = [Users]()
            for item in resalt!.documents {
                let user = Users(document: item)
                print("____________________________________\(item.documentID) => \(item.data())")
                array.append(user!)
            }
            //                print(array)
            self?.userAll = array
        }
//        print(self.userAll)
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
    func downUserData() {
        guard let token = UserDefaults.standard.string(forKey: "tokenUser") else {return}
        self.deviseToken = token
    }
}
