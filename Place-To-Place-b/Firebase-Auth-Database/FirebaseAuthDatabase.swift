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
    
    
    static let ref = Database.database().reference(withPath: "user")
    
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
        guard let imageData = photo.jpegData(compressionQuality: 0.1) else {return}
        
        let metodata = StorageMetadata()
        metodata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metodata) { (metodata, error) in
            guard let _ = metodata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }

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
    

    static func registerPhone(photo: UIImage?, lastName: String, uid: String, phoneNumber: String, deviseToken: String?, completion: @escaping (AuthResult) -> Void) {
        self.aploadImage(photoName: uid, photo: photo!, dataUrl: "avatars") { (myresalt) in
            switch myresalt {
            
            case .success(let url):
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "lastname": lastName as String,
                    "phoneNumber": phoneNumber as String,
                    "avatarsURL": url.absoluteString,
                    "uid": uid,
                    "deviseToken": deviseToken! as String,
                    "bandel": 0
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
   
    static func updateToken(key: String,
                            switchPlace: String,
                            userId: String,
                            nikNamePlace: String,
                            avatarNikPlace: String,
                            phoneNumber: String,
                            newToken: String,
                            ref: DatabaseReference) {
     
        let newPlace = PlaceModel(key: key, userId: userId, phoneNumber: phoneNumber, nikNamePlace: nikNamePlace, avatarNikPlace: avatarNikPlace, switchPlace: switchPlace, deviseToken: newToken)
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
    static func updateFavorit(key: String, favorit: [String], ref: DatabaseReference, completion: @escaping(Result <Void, Error>) -> Void) {
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "favorit": favorit as [String]
        ])
    }
    static func remowePlace(key: String, ref: DatabaseReference, image: String, gellery: [String]) {
        if image != "" {
            let desertRef = Storage.storage().reference().child(image)
            desertRef.delete { error in
                if let error = error {
                    print("Tap gesture delete\(error.localizedDescription)")
                }
            }
        }
        if gellery != [] {
            for imageG in gellery {
                let desertRef = Storage.storage().reference().child(imageG)
                desertRef.delete { error in
                  if let error = error {
                      print("Tap gesture delete\(error.localizedDescription)")
                  }
                }
            }
        }
        let placeRef = ref.child(key)
        placeRef.removeValue()
    }
    static func aploadGellery(key: String, gellery: [String], ref: DatabaseReference, completion: @escaping(Result <Void, Error>) -> Void) {
        
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "gellery": gellery as [String]
        ])
    }
    static func aploadRating(key: String, rating: [String: Int], ref: DatabaseReference, comletion: @escaping(Result <Void, Error>) -> Void) {
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "rating": rating as [String: Int]
        ])
    }
    static func aploadComents(key: String, coments: [String: String], ref: DatabaseReference, comletion: @escaping(Result <Void, Error>) -> Void) {
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "coments": coments as [String: String]
        ])
    }
    
    static func updateAvatarImage(user: Users, image: UIImage, completion: @escaping(Result <URL, Error>) -> Void){
        guard user.avatarsURL != nil else {return}
        let desertRef = Storage.storage().reference().child(user.avatarsURL ?? "")
        desertRef.delete { error in
            if let error = error {
                print("Tap gesture delete\(error.localizedDescription)")
            }
        }
        self.aploadImage(photoName: user.uid, photo: image, dataUrl: "avatars") { result in
            switch result {
                
            case .success(let url):
                completion(.success(url))
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).updateData([
                    "avatarsURL": url.absoluteString
                ]) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func newPlace(name: String,
                         userId: String,
                         phoneNumber: String,
                         phoneNumberArray: [String]?,
                         nikNamePlace: String,
                         avatarNikPlace: String,
                         location: String?,
                         latitude: String?,
                         Longitude: String?,
                         type: String?,
                         typeName: String?,
                         image: String?,
                         switchPlace: String,
                         deviseToken: String,
                         discription: String,
                         gellery: [String],
                         messageBool: Bool,
                         moderation: Bool,
                         ref: DatabaseReference,
                         completion: @escaping (AuthResult) -> Void) {
        
        guard let key = ref.child("name").childByAutoId().key else {return}

        let newPlace = PlaceModel(key: key, userId: userId, phoneNumber: phoneNumber, nikNamePlace: nikNamePlace, avatarNikPlace: avatarNikPlace, switchPlace: switchPlace, deviseToken: deviseToken)
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let now = df.string(from: Date())
                let placeRef = ref.child(newPlace.key)
                placeRef.setValue([
                    "userId": userId as String,
                    "name": name as String,
                    "key": key as String,
                    "nikNamePlace": nikNamePlace as String,
                    "avatarNikPlace" : avatarNikPlace as String,
                    "phoneNumber": phoneNumber as String,
                    "phoneNumberArray": (phoneNumberArray ?? []) as [String],
                    "location": (location ?? "") as String,
                    "latitude": (latitude ?? "") as String,
                    "Longitude": (Longitude ?? "") as String,
                    "type": (type ?? "") as String,
                    "typeName": (typeName ?? "no_image") as String,
                    "deviseToken": deviseToken as String,
                    "switchPlace": switchPlace as String,
                    "discription": discription as String,
                    "gellery": gellery as [String],
                    "image": (image ?? "") as String,
                    "messageBool": messageBool as Bool,
                    "moderation" : moderation as Bool,
                    "date": now as String
                ]){
                    (error: Error?, ref: DatabaseReference) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success)
                    }
                  }
        }
    
    static func updatePlace(key: String,
                            name: String,
                            userId: String,
                            nikNamePlace: String,
                            avatarNikPlace: String,
                            phoneNumber: String,
                            phoneNumberArray: [String]?,
                            location: String?,
                            latitude: String?,
                            Longitude: String?,
                            type: String?,
                            typeName: String?,
                            image: String?,
                            switchPlace: String,
                            deviseToken: String,
                            discription: String,
                            gellery: [String],
                            messageBool: Bool,
                            moderation: Bool,
                            ref: DatabaseReference,
                            completion: @escaping (AuthResult) -> Void) {
        let newPlace = PlaceModel(key: key, userId: userId, phoneNumber: phoneNumber, nikNamePlace: nikNamePlace, avatarNikPlace: avatarNikPlace, switchPlace: switchPlace, deviseToken: deviseToken)
                let placeRef = ref.child(newPlace.key)
                placeRef.updateChildValues([
                    "name": name as String,
                    "key": key as String,
                    "nikNamePlace": nikNamePlace as String,
                    "avatarNikPlace" : avatarNikPlace as String,
                    "phoneNumber": phoneNumber as String,
                    "phoneNumberArray": (phoneNumberArray ?? []) as [String],
                    "location": (location ?? "") as String,
                    "latitude": (latitude ?? "") as String,
                    "Longitude": Longitude! as String,
                    "type": (type ?? "") as String,
                    "typeName": (typeName ?? "no_image") as String,
                    "deviseToken": deviseToken as String,
                    "switchPlace": switchPlace as String,
                    "discription": discription as String,
                    "gellery": gellery as [String],
                    "image": (image ?? "") as String,
                    "messageBool": messageBool as Bool,
                    "moderation" : moderation as Bool
                ]){
                    (error: Error?, ref: DatabaseReference) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success)
                    }
                  }
            }
    
    static func aploadPlaceUserAvatar(key: String, image: String, completion: @escaping(Result <Void, Error>) -> Void) {
        
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "avatarNikPlace": image as String
        ]) { error, resalt in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    static func sendPushNotification(to token: String, title: String, badge: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "badge": badge, "sound": "default"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(keyNotisfactionFirebase, forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        print(task)
        task.resume()
    }
}


