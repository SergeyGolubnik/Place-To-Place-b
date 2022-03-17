//
//  RecentMessage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import Foundation
import Firebase


struct RecentMessage: Identifiable {
    
    var id: String {documentId}
    
    let documentId: String
    let text, name, tocen, phoneNumber: String
    let fromId, toId: String
    let profileImageUrl: String
    let imageURL: String
    let timestamp: Date
    let bedj: Int
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.text = data[FirebaseStatic.text] as? String ?? ""
        self.imageURL = data[FirebaseStatic.imageURL] as? String ?? ""
        self.name = data[FirebaseStatic.name] as? String ?? ""
        self.tocen = data[FirebaseStatic.tocen] as? String ?? ""
        self.phoneNumber = data[FirebaseStatic.phoneNumber] as? String ?? ""
        self.fromId = data[FirebaseStatic.fromId] as? String ?? ""
        self.toId = data[FirebaseStatic.toId] as? String ?? ""
        self.profileImageUrl = data[FirebaseStatic.profileImageUrl] as? String ?? ""
        self.bedj = data[FirebaseStatic.bedj] as? Int ?? 0
        self.timestamp = data[FirebaseStatic.timestamp] as? Date ?? Date()
    }
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil}
        guard let documentId = data["documentId"] as? String,
              let text = data[FirebaseStatic.text] as? String,
                let imageURL = data[FirebaseStatic.imageURL] as? String,
                let name = data[FirebaseStatic.name] as? String,
                let tocen = data[FirebaseStatic.tocen] as? String,
                let phoneNumber = data[FirebaseStatic.phoneNumber] as? String,
                let fromId = data[FirebaseStatic.fromId] as? String,
                let toId = data[FirebaseStatic.toId] as? String,
                let profileImageUrl = data[FirebaseStatic.profileImageUrl] as? String,
                let bedj = data[FirebaseStatic.bedj] as? Int,
                let timestamp = data[FirebaseStatic.timestamp] as? Date
        else { return nil }
        
        self.documentId = documentId
        self.text = text
        self.imageURL = imageURL
        self.name = name
        self.tocen = tocen
        self.phoneNumber = phoneNumber
        self.fromId = fromId
        self.toId = toId
        self.profileImageUrl = profileImageUrl
        self.bedj = bedj
        self.timestamp = timestamp
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let documentId = data["documentId"] as? String,
              let text = data[FirebaseStatic.text] as? String,
                let imageURL = data[FirebaseStatic.imageURL] as? String,
                let name = data[FirebaseStatic.name] as? String,
                let tocen = data[FirebaseStatic.tocen] as? String,
                let phoneNumber = data[FirebaseStatic.phoneNumber] as? String,
                let fromId = data[FirebaseStatic.fromId] as? String,
                let toId = data[FirebaseStatic.toId] as? String,
                let profileImageUrl = data[FirebaseStatic.profileImageUrl] as? String,
                let bedj = data[FirebaseStatic.bedj] as? Int,
                let timestamp = data[FirebaseStatic.timestamp] as? Date
        else { return nil }
        
        self.documentId = documentId
        self.text = text
        self.imageURL = imageURL
        self.name = name
        self.tocen = tocen
        self.phoneNumber = phoneNumber
        self.fromId = fromId
        self.toId = toId
        self.profileImageUrl = profileImageUrl
        self.bedj = bedj
        self.timestamp = timestamp
    }
    var timeAgo: String {
        let formater = RelativeDateTimeFormatter()
        formater.unitsStyle = .abbreviated
        print(timestamp)
        print("\(Date())")
        print(formater.localizedString(for: timestamp, relativeTo: Date()))
        return formater.localizedString(for: timestamp, relativeTo: Date())
    }
}
