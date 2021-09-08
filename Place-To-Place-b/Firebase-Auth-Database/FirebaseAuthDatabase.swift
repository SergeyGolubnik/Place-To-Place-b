//
//  FirebaseAuthDatabase.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import Firebase
import UIKit
import FirebaseStorage

class FirebaseAuthDatabase {
    
    static let storageRef = Storage.storage().reference()
    
    static var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    static var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    static var chatsRef: StorageReference {
        return storageRef.child("chats")
    }
    
    static func aploadImage(photoName: String, photo: UIImage, dataUrl: String, completion: @escaping(Result <URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child(dataUrl).child(photoName)
        guard let imageData = photo.jpegData(compressionQuality: 0.2) else {return}
        
        let metodata = StorageMetadata()
        metodata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metodata) { (metodata, error) in
            guard let _ = metodata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
//    static func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {return}
//
//        let metodata = StorageMetadata()
//        metodata.contentType = "image/jpeg"
//
//        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
//        let uid: String = Auth.auth().currentUser!.uid
//        let chatName = [chat.friendUsername, uid].joined()
//        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metodata) { metodata, error in
//            guard let _ = metodata else {
//                completion(.failure(error!))
//                return
//            }
//            self.chatsRef.child(chatName).child(imageName).downloadURL { (url, error) in
//                guard let dowladURL = url else {
//                    completion(.failure(error!))
//                    return
//                }
//                completion(.success(dowladURL))
//            }
//
//        }
//
//        
//    }
    static func dowloudImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
    
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaBite = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaBite) { (data, error) in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
    static func loginPressed(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard
              Validators.isSimpleEmail(email) == true, password != "" else {
            completion(false, "E-mail или пароль введены не правильно")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                
                completion(false, (error?.localizedDescription)!)
                
                return
            }
            if user != nil {
                completion(true, (user?.user.email)!)
                return
            }
            completion(false, "Не правильно введены данные")
            
        }
    }
    
    static func register(photo: UIImage?, lastName: String?, email: String?, password: String?, deviseToken: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilled(
                                  lastName: lastName,
                                  email: email,
                                  password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard let email = email, let password = password else {
            completion(.failure(AuthError.unknownError))
            return
        }
        
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        guard let lastName = lastName else {
            completion(.failure(AuthError.noNoFirstname))
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) {  (result, error) in
            guard let result = result else { completion(.failure(error!))
                return}
            var photo = photo
            if (photo == nil) {
                photo = UIImage(named: "avatar-1")
            }
            
            self.aploadImage(photoName: result.user.uid, photo: photo!, dataUrl: "avatars") { (myresalt) in
                switch myresalt {
                
                case .success(let url):
                    let db = Firestore.firestore()
                    db.collection("users").document(result.user.uid).setData([
                        "lastname": lastName as String,
                        "email": email as String,
                        "avatarsURL": url.absoluteString,
                        "uid": result.user.uid,
                        "deviseToken": deviseToken! as String
                    ]) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        completion(.success)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    static func newPlace(name: String,
                         userId: String,
                         location: String?,
                         latitude: String?,
                         Longitude: String?,
                         type: String?,
                         rating: [String: Int],
                         image: UIImage?,
                         switchPlace: String,
                         deviseToken: String,
                         discription: String,
                         gellery: [String],
                         favorit: [String],
                         ref: DatabaseReference,
                         completion: @escaping (AuthResult) -> Void) {
        
        guard let key = ref.child("name").childByAutoId().key else {return}

        aploadImage(photoName: key, photo: image!, dataUrl: "PlacePhoto") {(resalt) in
            switch resalt {
            
            case .success(let url):
                let newPlace = PlaceModel(key: key, userId: userId, switchPlace: switchPlace, deviseToken: deviseToken)
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                let now = df.string(from: Date())
                let placeRef = ref.child(newPlace.key)
                placeRef.setValue([
                    "userId": userId as String,
                    "name": name as String,
                    "key": key as String,
                    "location": location! as String,
                    "latitude": latitude! as String,
                    "Longitude": Longitude! as String,
                    "rating": rating as [String: Int],
                    "type": type! as String,
                    "deviseToken": deviseToken as String,
                    "switchPlace": switchPlace as String,
                    "discription": discription as String,
                    "gellery": gellery as [String],
                    "favorit": favorit as [String],
                    "image": url.absoluteString,
                    "date": now as String
                ])
                completion(.success)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func updatePlace(key: String,
                            name: String,
                            userId: String,
                            location: String?,
                            latitude: String?,
                            Longitude: String?,
                            type: String?,
                            rating: [String: Int],
                            image: UIImage?,
                            switchPlace: String,
                            deviseToken: String,
                            discription: String,
                            gellery: [String],
                            favorit: [String],
                            ref: DatabaseReference,
                            completion: @escaping (AuthResult) -> Void) {
        
        aploadImage(photoName: key, photo: image!, dataUrl: "PlacePhoto") {(resalt) in
            
            switch resalt {
            
            case .success(let url):
                let newPlace = PlaceModel(key: key, userId: userId, switchPlace: switchPlace, deviseToken: deviseToken)
                let placeRef = ref.child(newPlace.key)
                placeRef.updateChildValues([
                    "name": name as String,
                    "key": key as String,
                    "location": location! as String,
                    "latitude": latitude! as String,
                    "Longitude": Longitude! as String,
                    "type": type! as String,
                    "rating": rating as [String: Int],
                    "deviseToken": deviseToken as String,
                    "switchPlace": switchPlace as String,
                    "discription": discription as String,
                    "gellery": gellery as [String],
                    "favorit": favorit as [String],
                    "image": url.absoluteString
                ])
                
                completion(.success)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func updateToken(key: String,
                            switchPlace: String,
                            userId: String,
                            newToken: String,
                            ref: DatabaseReference) {
     
        let newPlace = PlaceModel(key: key, userId: userId, switchPlace: switchPlace, deviseToken: newToken)
        let placeRef = ref.child(newPlace.key)
        placeRef.updateChildValues([
            "deviseToken": newToken as String
        ])
    }
    static func uploadTokenUser(userId: String, newToken: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(["deviseToken": newToken as String]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    static func updateFavorit(key: String,
                            favorit: [String],
                            ref: DatabaseReference) {
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "favorit": favorit as [String]
        ])
    }
    static func aploadGellery(key: String, gellery: [String], ref: DatabaseReference, completion: @escaping(Result <Void, Error>) -> Void) {
        
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "gellery": gellery as [String]
        ])
    }
}