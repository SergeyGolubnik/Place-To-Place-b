//
//  ChatMessage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI
import Firebase

struct ChatMessage: Identifiable {
    var id: String {documentId}
    
    let documentId: String
    
    let fromId, toId, image, text: String
    let date: Timestamp
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        
        self.fromId = data[FirebaseStatic.fromId] as? String ?? ""
        self.toId = data[FirebaseStatic.toId] as? String ?? ""
        self.text = data[FirebaseStatic.text] as? String ?? ""
        self.image = data[FirebaseStatic.imageURL] as? String ?? ""
        self.date = data[FirebaseStatic.timestamp] as? Timestamp ?? Timestamp()
    }
}
