//
//  ChatLogView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore





struct ChatLogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ChatLogViewModel
    @State var popapSetings = false
    @State var blokUser = false
    @State var blokUserTo = false
    @State var uidFrend = ""
    
    var body: some View {
        NavigationView {
            
            VStack{
                
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack{
                            
                            ForEach(vm.chatMessages) {message in
                                MessageView(message: message)
                            }
                            HStack{ Spacer() }
                            .id("Empty")
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                            }
                        }
                        
                    }
                    
                }
                Text(vm.messageError)
                
                            .background(Color(.init(white: 0.95, alpha: 1)))
                if blokUser {
                    Text("\(vm.chatUser?.name ?? "") не готов(а) с вами общаться")
                        .padding()
                } else {
                    
                    HStack {
                        //                    Image(systemName: "photo.on.rectangle")
                        //                        .font(.system(size: 24))
                        //                        .foregroundColor(Color(.darkGray))
                        TextEditor(text: $vm.chatText)
                            .frame(height: 35)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        
                        Button {
                            //                    if vm.chatText != "" {
                            vm.handleSend()
                            
                            //                    }
                        } label: {
                            Text("Send")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(4)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(colorApp.ignoresSafeArea())
                }
            }
            .navigationBarColor(uiColorApp)
            .navigationTitle(vm.chatUser?.name ?? "")
            .toolbar  {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Выйти")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button {
                        withAnimation {
                            popapSetings.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .tolbarPopover(show: $popapSetings, content: {
                Button {
                    let arrayUser = [vm.chatCurentUser?.uid, vm.chatUser?.uid]
                    
                    let uid = FirebaseData.shared.user.uid
                    if blokUserTo {
                        FirebaseData.shared.firestore.collection("users").document(uid).collection("blokUser").document(uidFrend).delete() { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        blokUserTo = false
                    } else {
                        
                        FirebaseData.shared.firestore.collection("users").document(uid).collection("blokUser").document(uidFrend).setData([
                            "blokUser": uidFrend
                        ]) { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        blokUserTo = true
                    }
                    print("\(arrayUser)")
                } label: {
                    Text(blokUserTo ? "Разблокировать" : "Заблокировать" )
                }
            })
            .onAppear(perform: {
                
                let arrayUser = [vm.chatCurentUser?.uid, vm.chatUser?.uid]
                let uid = FirebaseData.shared.user.uid
                
                for userFr in arrayUser {
                    if uid != userFr {
                        uidFrend = userFr ?? ""
                    }
                }
                FirebaseData.shared.firestore.collection("users").document(uidFrend).collection("blokUser").getDocuments() {(resalt, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let resalt = resalt else {return}
                    for item in resalt.documents {
                        guard let userBlok = BlokUser(document: item) else {return}
                        if userBlok.blokUser == uid {
                            self.blokUser = true
                        }
                    }
                    
                }
                FirebaseData.shared.firestore.collection("users").document(uid).collection("blokUser").getDocuments() {(resalt, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let resalt = resalt else {return}
                    for item in resalt.documents {
                        guard let userBlok = BlokUser(document: item) else {return}
                        if userBlok.blokUser == uidFrend {
                            self.blokUserTo = true
                        }
                        
                        
                    }
                    
                }
                print(blokUser)
                print(blokUserTo)
                
            })
            .onDisappear {
                vm.firestoreLisener?.remove()
            }
        }
    }
}
struct MessageView: View {
    let message: ChatMessage
    var body: some View {
        
        HStack{
            if message.fromId == FirebaseData.shared.auth.currentUser?.uid {
                Spacer()
                HStack{
                    Text(message.text)
                        .foregroundColor(.black)
                }
                .padding()
                .background(colorApp)
                .cornerRadius(8)
            } else {
                
                HStack{
                    Text(message.text)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .padding(.top, 8)
        
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        let chatLog = ChatLogViewModel(chatUser: ChatUsers(name: "Sergey", uid: "1234567", phoneNumber: "7903888888234", profileImage: "", token: ""), chatCurentUser: ChatUsers(name: "", uid: "1234567", phoneNumber: "7903888888234", profileImage: "", token: ""))
//                NavigationView {
                    ChatLogView(vm: chatLog)
//                }
//        MainMessagesView()
        
    }
}

