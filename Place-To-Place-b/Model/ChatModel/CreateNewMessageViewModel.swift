//
//  CreateNewMessageViewModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import Foundation


class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [ChatUsers]()
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseData.shared.firestore.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                self.users.append(.init(data: data))
            })
        }
    }
}
