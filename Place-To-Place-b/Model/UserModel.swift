//
//  UserModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import UIKit
import Firebase

struct Users: Hashable, Decodable {
    let uid: String
    let email: String
    var lastName: String?
    var avatarsURL: String?
    var deviseToken: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
   
    
    init(snapshot: NSDictionary) {
        let snapshotVaiue = snapshot as! [String: Any]
        uid = snapshotVaiue["uid"] as! String
        email = snapshotVaiue["email"] as! String
        avatarsURL = snapshotVaiue["avatarsURL"] as? String
        lastName = snapshotVaiue["lastname"] as? String
        deviseToken = snapshotVaiue["deviseToken"] as? String
    }
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil}
        guard let lastName = data["lastname"] as? String,
              let email = data["email"] as? String,
              let avatarsURL = data["avatarsURL"] as? String,
              let deviseToken = data["deviseToken"] as? String,
              let uid = data["uid"] as? String else { return nil }
        
        self.lastName = lastName
        self.email = email
        self.avatarsURL = avatarsURL
        self.uid = uid
        self.deviseToken = deviseToken
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let lastName = data["lastname"] as? String,
              let email = data["email"] as? String,
              let avatarsURL = data["avatarsURL"] as? String,
              let deviseToken = data["deviseToken"] as? String,
              let uid = data["uid"] as? String else { return nil }
        
        self.lastName = lastName
        self.email = email
        self.avatarsURL = avatarsURL
        self.uid = uid
        self.deviseToken = deviseToken
    }
    var representation: [String: Any] {
        var rep = ["lastname": lastName]
        rep["email"] = email
        rep["avatarsURL"] = avatarsURL
        rep["uid"] = uid
        rep["deviseToken"] = deviseToken
        return rep as [String : Any]
    }
    init(lastName: String, email: String, avatarsURL: String, uid: String, deviseToken: String) {
        self.lastName = lastName
        self.email = email
        self.avatarsURL = avatarsURL
        self.uid = uid
        self.deviseToken = deviseToken
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: Users, rhs: Users) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return lastName!.lowercased().contains(lowercasedFilter)
    }
}
