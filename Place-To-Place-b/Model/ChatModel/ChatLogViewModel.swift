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
    @Published var imageMessageURL = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var blokUser = false
    @Published var blokUserTo = false
    @Published var bedj = 0
    @Published var bedjBig = 0
    
    var messageError = ""
    var chatUser: ChatUsers?
    var chatCurentUser: ChatUsers?
    private var usersRef: CollectionReference {
        return FirebaseData.shared.db.collection("users")
    }
    var summBig = 0
    var summBedj = 0
    init(chatUser: ChatUsers?, chatCurentUser: ChatUsers?) {
        self.chatUser = chatUser
        self.chatCurentUser = chatCurentUser
//        self.updateBadj()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fetchMessage()
        }
        
    }
    var firestoreLisener: ListenerRegistration?
    var firestoreLisenerUserBlok: ListenerRegistration?
    var firestoreLisenerUserBlokTo: ListenerRegistration?
    var downFrendBedjLisener: ListenerRegistration?
    var updateBadjLisener: ListenerRegistration?
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.count += 1
                }
            }
       
        self.blokUserUid()
    }
    func handleSend() {
        downFrendBedj()
        guard let fromId = FirebaseData.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        let document = FirebaseData.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        let messageData = [FirebaseStatic.fromId: fromId, FirebaseStatic.toId: toId, FirebaseStatic.text: chatText, FirebaseStatic.imageURL: imageMessageURL, "timestamp": Date()] as [String: Any]
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
        self.imageMessageURL = ""
        self.updateBadj()
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
            FirebaseStatic.timestamp: Date(),
            FirebaseStatic.text: self.chatText,
            FirebaseStatic.imageURL: self.imageMessageURL,
            FirebaseStatic.fromId: uid,
            FirebaseStatic.tocen: chatUser.token,
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
            FirebaseStatic.timestamp: Date(),
            FirebaseStatic.text: self.chatText,
            FirebaseStatic.imageURL: self.imageMessageURL,
            FirebaseStatic.fromId: toId,
            FirebaseStatic.tocen: FirebaseData.shared.downUserData(),
            FirebaseStatic.toId: uid,
            FirebaseStatic.profileImageUrl: chatCurentUser.profileImage,
            FirebaseStatic.name: chatCurentUser.name,
            FirebaseStatic.bedj: bedj
        ] as [String: Any]
        
        documentTo.setData(dataTo) { error in
            if let error = error {
                print(error.localizedDescription)
                self.messageError = error.localizedDescription
                return
            }
            self.bedjBigMetod()
            
        }
    }
    func blokUserUid() {
        guard let fromId = FirebaseData.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        firestoreLisenerUserBlok?.remove()
        firestoreLisenerUserBlok = FirebaseData.shared.firestore.collection("users").document(toId).collection("blokUser").addSnapshotListener {quereSnapshot, error in
            if let error = error {
                print("______________________________\(error.localizedDescription)")
                return
            }
            var array = [String]()
            quereSnapshot?.documentChanges.forEach({ change in
                    let data = change.document.data()
                guard let userBlok = BlokUser(data: data) else {return}
                    array.append(userBlok.blokUser)
                
            })
            
            self.blokUser = array.contains(fromId)
        }
        firestoreLisenerUserBlokTo?.remove()
        firestoreLisenerUserBlokTo = FirebaseData.shared.firestore.collection("users").document(fromId).collection("blokUser").addSnapshotListener { quereSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var array = [String]()
            quereSnapshot?.documentChanges.forEach({ change in
                    let data = change.document.data()
                guard let userBlok = BlokUser(data: data) else {return}
                    array.append(userBlok.blokUser)
                
            })
            self.blokUserTo = array.contains(toId)
        }
        
        
    }
//    получаем количество бейджев в последних сообщениях друга
    func updateBadj() {
        updateBadjLisener?.remove()
        guard let fromId = FirebaseData.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        updateBadjLisener = FirebaseData.shared.firestore.collection("recent_message").document(toId).collection("messages").document(fromId).addSnapshotListener{ document, error in
            
            if let document = document {
                guard let dataDescription = document.data() else {return}
                let recient = RecentMessage(documentId: document.documentID, data: dataDescription)
                self.bedj = recient.bedj
                print("получаем количество бейджев в последних сообщениях друга: \(recient.bedj)")
               
            } else {
              print("Document does not exist in cache")
            }
          }
    }
//    плюсуем бейджи другу в юзере
    func bedjBigMetod() {
        let summ = bedjBig + 1
        guard let toId = chatUser?.uid else {return}
        FirebaseData.shared.firestore.collection("users").document(toId).updateData([
            "bandel": summ
        ])
    }
//    Загрузка сколько бейджев у юзера
    func downFrendBedj() {
        downFrendBedjLisener?.remove()
        guard let toId = chatUser?.uid else {return}
        let docRef = usersRef.document(toId)
        downFrendBedjLisener = docRef.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                guard let muser = Users(document: document) else {
                    print(UserError.cannotUnwrapToUser)
                    return
                }
                print("загрузка бейджев в данный момент ChatLogViewModel метод downFrendBedj\(muser.bandel)")
                self.bedjBig = muser.bandel
            } else {
                print("Ошибка в загрузке френда класс ChatLogViewModel метод downFrendBedj")
                return
            }
        }
    }
//    Удаление и минусовка бейджев у себя
    func chatBedjIcon() {
        guard let toId = chatUser?.uid else {return}
        let uid = FirebaseData.shared.user.uid
        
//       загрузка сколько на данный момент бейджев
        
        let docRef = usersRef.document(uid)
        docRef.getDocument { document, error in
            if let document = document {
                guard let muser = Users(document: document) else {
                    print("Ошибка в загрузке у себя бейджев класс ChatLogViewModel метод chatBedjIcon")
                    return
                }
                print("загрузка бейджев в данный момент у меня класс ChatLogViewModel метод chatBedjIcon \(muser.bandel)")
                self.summBig = muser.bandel
                FirebaseData.shared.firestore.collection("recent_message").document(uid).collection("messages").document(toId).getDocument{ document, error in
                    if let document = document {
                        guard let dataDescription = document.data() else {return}
                        let recient = RecentMessage(documentId: document.documentID, data: dataDescription)
                        self.summBedj = recient.bedj
                        print("Получили свои беджи в последних сообщениях: \(recient.bedj)")
                        self.deleteBedj()
                    } else {
                      print("ошибка класс ChatLogViewModel метод chatBedjIcon ")
                    }
                  }
            } else {
                print("Ошибка в загрузке френда класс ChatLogViewModel метод chatBedjIcon")
                return
            }
        }
        
        
        print("summBig класс ChatLogViewModel метод chatBedjIcon __________________\(summBig)")
        print("summBedj класс ChatLogViewModel метод chatBedjIcon __________________\(summBedj)")
       
    }
    func deleteBedj() {
        guard let toId = chatUser?.uid else {return}
        let uid = FirebaseData.shared.user.uid
        
        if summBig >= summBedj {
            let summ = summBig - summBedj
            print("summ класс ChatLogViewModel метод chatBedjIcon __________________\(summ)")
            FirebaseData.shared.firestore.collection("users").document(uid).updateData([
                "bandel": summ
            ]) { error in
                if let error = error {
                    print("ошибка класс ChatLogViewModel метод chatBedjIcon __________________\(error.localizedDescription)")
                } else {
                    print("summ класс ChatLogViewModel метод chatBedjIcon __________________\(summ)")
                    let documentTo = FirebaseData.shared.firestore
                        .collection("recent_message")
                        .document(uid)
                        .collection("messages")
                        .document(toId)
                    let dataTo = [
                        FirebaseStatic.bedj: 0
                    ] as [String: Any]
                    documentTo.updateData (dataTo) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    }
                }
            }
            return
        } else {
            FirebaseData.shared.firestore.collection("users").document(uid).updateData([
                "bandel": 0
            ]) { error in
                if let error = error {
                    print("ошибка класс ChatLogViewModel метод chatBedjIcon __________________\(error.localizedDescription)")
                } else {
                    print("summ класс ChatLogViewModel метод chatBedjIcon \(0)")
                    let documentTo = FirebaseData.shared.firestore
                        .collection("recent_message")
                        .document(uid)
                        .collection("messages")
                        .document(toId)
                    let dataTo = [
                        FirebaseStatic.bedj: 0
                    ] as [String: Any]
                    documentTo.updateData (dataTo) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    }
                }
            }
        }
    }
    @Published var count = 0
}
