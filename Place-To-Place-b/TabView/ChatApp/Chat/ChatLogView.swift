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
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                        .foregroundColor(Color(.darkGray))
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
            }
            .navigationBarTitleDisplayMode(.inline)
            
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
        //        NavigationView {
        //            ChatLogView(chatUser: .init(data: ["uid": "jtscJf1sAocUXWIcHKjvZfVjGma2", "name": "Sergey2", "email": "sergey82823@mail.ru"]))
        //        }
        MainMessagesView()
        
    }
}
