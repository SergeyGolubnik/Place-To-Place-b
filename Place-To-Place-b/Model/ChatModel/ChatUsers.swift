//
//  ChatUsers.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import Foundation



struct ChatUsers: Identifiable {
    var id: String {
        uid
    }
    
    let name, uid, email, profileImage, token :String
    
    init(data: [String: Any]) {
        self.name = data["lastname"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImage = data["avatarsURL"] as? String ?? ""
        self.token = data["deviseToken"] as? String ?? ""
    }
    init(name: String, uid: String, email: String, profileImage: String, token :String){
        self.name = name
        self.uid = uid
        self.email = email
        self.profileImage = profileImage
        self.token = token
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: ChatUsers, rhs: ChatUsers) -> Bool {
        return lhs.uid == rhs.uid
    }
}
