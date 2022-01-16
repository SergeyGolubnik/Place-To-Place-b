//
//  ChatLogViewModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//


import Foundation
import Firebase


class ChatLogViewModel: ObservableObject {
    @Published var chatText = ""
    @Published var chatMessages = [ChatMessage]()
    var messageError = ""
    var chatUser: ChatUsers?
    var chatCurentUser: ChatUsers?
    
    init(chatUser: ChatUsers?, chatCurentUser: ChatUsers?) {
        self.chatUser = chatUser
        self.chatCurentUser = chatCurentUser
        fetchMessage()
    }
    var firestoreLisener: ListenerRegistration?
    
    func fetchMessage() {
        guard let fromId = FirebaseData.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        self.messageError = ""
        firestoreLisener?.remove()
        chatMessages.removeAll()
        firestoreLisener = FirebaseData.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseStatic.timestamp)
            .addSnapshotListener { quereSnapshot, error in
                if let error = error {
                    self.messageError = error.localizedDescription
                    return
                }
                quereSnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.count += 1
                }
            }
        
    }
    func handleSend() {
        guard let fromId = FirebaseData.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        let document = FirebaseData.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        let messageData = [FirebaseStatic.fromId: fromId, FirebaseStatic.toId: toId, FirebaseStatic.text: chatText, "timestamp": Timestamp()] as [String: Any]
        document.setData(messageData) { error in
            if let error = error {
                print(error.localizedDescription)
                self.messageError = error.localizedDescription
                return
            }
        }
        let recipientMessageDocument = FirebaseData.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error.localizedDescription)
                self.messageError = error.localizedDescription
                return
            }
        }
        self.persistRecentMessage()
        self.count += 1
        
        self.chatText = ""
    }
    private func persistRecentMessage() {
        guard let chatUser = chatUser else {return messageError = "chatUser nil"}
        guard let chatCurentUser = chatCurentUser else {return messageError = "chatCurentUser nil"}

        let uid = chatCurentUser.uid
        
        let toId = chatUser.uid
        let document = FirebaseData.shared.firestore
            .collection("recent_message")
            .document(uid)
            .collection("messages")
            .document(toId)
        let data = [
            FirebaseStatic.timestamp: Timestamp(),
            FirebaseStatic.text: self.chatText,
            FirebaseStatic.fromId: uid,
            FirebaseStatic.toId: toId,
            FirebaseStatic.profileImageUrl: chatUser.profileImage,
            FirebaseStatic.name: chatUser.name
        ] as [String: Any]
        document.setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                self.messageError = error.localizedDescription
                return
            }
        }
        let documentTo = FirebaseData.shared.firestore
            .collection("recent_message")
            .document(toId)
            .collection("messages")
            .document(uid)
        let dataTo = [
            FirebaseStatic.timestamp: Timestamp(),
            FirebaseStatic.text: self.chatText,
            FirebaseStatic.fromId: toId,
            FirebaseStatic.toId: uid,
            FirebaseStatic.profileImageUrl: chatCurentUser.profileImage,
            FirebaseStatic.name: chatCurentUser.name
        ] as [String: Any]
        documentTo.setData(dataTo) { error in
            if let error = error {
                print(error.localizedDescription)
                self.messageError = error.localizedDescription
                return
            }
        }
    }
    
    @Published var count = 0
}
