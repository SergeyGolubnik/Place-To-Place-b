//
//  RecentMessage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import Foundation


struct RecentMessage: Identifiable {
    
    var id: String {documentId}
    
    let documentId: String
    let text, name, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.text = data[FirebaseStatic.text] as? String ?? ""
        self.name = data[FirebaseStatic.name] as? String ?? ""
        self.email = data[FirebaseStatic.email] as? String ?? ""
        self.fromId = data[FirebaseStatic.fromId] as? String ?? ""
        self.toId = data[FirebaseStatic.toId] as? String ?? ""
        self.profileImageUrl = data[FirebaseStatic.profileImageUrl] as? String ?? ""
        self.timestamp = data[FirebaseStatic.toId] as? Date ?? Date()
    }
    var timeAgo: String {
        let formater = RelativeDateTimeFormatter()
        formater.unitsStyle = .abbreviated
        return formater.localizedString(for: timestamp, relativeTo: Date())
    }
}
