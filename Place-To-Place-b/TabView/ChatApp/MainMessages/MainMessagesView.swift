//
//  MainMessagesView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase






struct MainMessagesView: View {
    @ObservedObject var vw = MainMessagesViewModel()
    @StateObject var createModel = CreateNewMessageViewModel()
    @State var shouIdNavigateToChatLogView = false
    //    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    @State var chatUser: ChatUsers?
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil, chatCurentUser: nil)
    private var customNavBar: some View {
        HStack(spacing: 16) {
            WebImage(url: URL(string: vw.chatCurentUser?.profileImage ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 4) {
                Text(vw.chatCurentUser?.name ?? "")
                    .font(.system(size: 24, weight: .bold))
            }
            Spacer()
        }
        .padding()
        .background(colorApp)
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                customNavBar
                messagesView
            }
            .navigationBarColor(uiColorApp)
            .padding(.bottom, 50)
            .navigationBarHidden(true)
        }
    }
    
    private var messagesView: some View {
        List {
            
            ForEach(vw.recientMessage) { recientMessage in
                VStack {
                    Button {
                        let uid = recientMessage.toId
                        self.chatUser = ChatUsers(name: recientMessage.name, uid: uid, phoneNumber: recientMessage.phoneNumber, profileImage: recientMessage.profileImageUrl, token: "")
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                        self.chatLogViewModel.fetchMessage()
                        self.shouIdNavigateToChatLogView.toggle()
                        
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recientMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading,spacing: 8) {
                                Text(recientMessage.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recientMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }
                            Spacer()
                            
                            //                            Text(recientMessage.timeAgo)
                            //                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }.onDelete { indexSet in
                deleteChat(indexSet: indexSet)
            }
            .fullScreenCover(isPresented: $shouIdNavigateToChatLogView) {
                ChatLogView(vm: chatLogViewModel)
                
            }
        }
        .listStyle(.plain)
    }
    
    
    private func deleteChat(indexSet: IndexSet){
        var messageR: RecentMessage!
        for index in indexSet {
            messageR = vw.recientMessage[index]
            
            
        }
        deleteFirestore(messageR: messageR, indexSet: indexSet)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            print(vw.recientMessage)
        }
        
    }
    private func deleteFirestore(messageR: RecentMessage, indexSet: IndexSet) {
        let uid = FirebaseData.shared.auth.currentUser?.uid == messageR.fromId ? messageR.toId : messageR.fromId
        self.chatUser = ChatUsers(name: messageR.name, uid: uid, phoneNumber: messageR.phoneNumber, profileImage: messageR.profileImageUrl, token: "")
        self.chatLogViewModel.chatUser = self.chatUser
        self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
        self.chatLogViewModel.fetchMessage()
        let uidR = messageR.fromId
        print(uidR)
        let db = Firestore.firestore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            print(chatLogViewModel.chatMessages)
            for document in chatLogViewModel.chatMessages {
                db.collection("messages").document(uidR).collection(messageR.toId).document(document.documentId).delete() { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    }
                }
            }
        }
        db.collection("recent_message").document(uidR).collection("messages").document(messageR.toId).delete() { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                db.collection("messages").document(uidR).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        vw.recientMessage.remove(atOffsets: indexSet)
                    }
                }
            }
        }
        
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
    }
}
