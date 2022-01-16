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
    @StateObject var vw = MainMessagesViewModel()
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
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
//            Button {
//                shouldShowLogOutOptions.toggle()
//            } label: {
//                Image(systemName: "gear")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(Color(.label))
//            }
        }
        .padding()
        .background(colorApp)
//        .actionSheet(isPresented: $shouldShowLogOutOptions) {
//            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
//                .destructive(Text("Sign Out"), action: {
//                    print("handle sign out")
//                    vw.handleSignOut()
//                }),
//                .cancel()
//            ])
//        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                customNavBar
                messagesView
//                NavigationLink("", isActive: $shouIdNavigateToChatLogView) {
//                    ChatLogView(vm: chatLogViewModel)
//                }
            }
            .navigationBarColor(uiColorApp)
//            .overlay(newMessageButton, alignment: .bottom)
            .padding(.bottom, 50)
            .navigationBarHidden(true)
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            
            ForEach(vw.recientMessage) { recientMessage in
                VStack {
                    Button {
                        print("recientMessage nil image \(recientMessage.profileImageUrl)")
                        let uid = FirebaseData.shared.auth.currentUser?.uid == recientMessage.fromId ? recientMessage.toId : recientMessage.fromId
                        self.chatUser = ChatUsers(name: recientMessage.name, uid: uid, email: recientMessage.email, profileImage: recientMessage.profileImageUrl, token: "")
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
                            
                            Text(recientMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
                .fullScreenCover(isPresented: $shouIdNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                    
                }
        }
    }
    
//    private var newMessageButton: some View {
//            Button {
//                shouldShowNewMessageScreen.toggle()
//            } label: {
//                HStack {
//                    Spacer()
//                    Text("+ New Message")
//                        .font(.system(size: 16, weight: .bold))
//                    Spacer()
//                }
//                .foregroundColor(.white)
//                .padding(.vertical)
//                .background(Color.blue)
//                .cornerRadius(32)
//                .padding(.horizontal)
//                .shadow(radius: 15)
//            }
//        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
//            CreateNewMessageView(didSelectNewUser: {user in
//                self.chatUser = user
//                self.shouIdNavigateToChatLogView.toggle()
//                self.chatLogViewModel.chatUser = user
//                self.chatLogViewModel.chatCurentUser = vw.chatCurentUser
//                self.chatLogViewModel.fetchMessage()
//                print(user.name)
//            })
//        }
//    }
    
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        
        MainMessagesView()
    }
}
