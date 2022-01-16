//
//  MainMessagesViewModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import Foundation
import Firebase



class MainMessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatCurentUser: ChatUsers?
    @Published var isUserCurrentlyLoggenOut = false
    @Published var recientMessage = [RecentMessage]()
    
    init() {
        self.isUserCurrentlyLoggenOut = FirebaseData.shared.auth.currentUser?.uid == nil
        
        fetchCurrentUser()
        fethRecientMessage()
    }
    
    private var firestoreLisener: ListenerRegistration?
    
    func fethRecientMessage() {
        guard let uid = FirebaseData.shared.auth.currentUser?.uid else {return}
        //        firestoreLisener?.remove()
        //        self.recientMessage.removeAll()
        FirebaseData.shared.firestore
            .collection("recent_message")
            .document(uid)
            .collection("messages")
            .order(by: FirebaseStatic.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recientMessage.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recientMessage.remove(at: index)
                    }
                    self.recientMessage.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
    func fetchCurrentUser() {
        guard let uid = FirebaseData.shared.auth.currentUser?.uid else {return}
        FirebaseData.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
            guard let data = snapshot?.data() else {return}
            self.chatCurentUser = ChatUsers(data: data)
        }
    }
    
    
    func handleSignOut() {
        isUserCurrentlyLoggenOut.toggle()
        try? FirebaseData.shared.auth.signOut()
    }
}
