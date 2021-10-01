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
    var ref: DatabaseReference!
    var user: Users!
    let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    @Published var users: Users!
    @Published var places = [PlaceModel]()
    
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
    
}
