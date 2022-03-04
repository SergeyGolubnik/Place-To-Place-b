//
//  ChatMessage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI

struct ChatMessage: Identifiable {
    var id: String {documentId}
    
    let documentId: String
    
    let fromId, toId, text: String
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        
        self.fromId = data[FirebaseStatic.fromId] as? String ?? ""
        self.toId = data[FirebaseStatic.toId] as? String ?? ""
        self.text = data[FirebaseStatic.text] as? String ?? ""
    }
}
