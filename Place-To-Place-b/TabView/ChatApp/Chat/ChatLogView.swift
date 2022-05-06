//
//  ChatLogView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI




struct ChatLogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: ChatLogViewModel
    @State var popapSetings = false
    @State var showImagePicker: Bool = false
    @State var image = UIImage(named: "avatar-1")
    @State var showSheet: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
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
                if vm.blokUser {
                    Text("\(vm.chatUser?.name ?? "") не готов(а) с вами общаться")
                        .padding()
                } else {
                    
                    HStack {
                        Button {
                            showSheet = true
                        } label: {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.darkGray))
                        }
                        
                        
                        TextEditor(text: $vm.chatText)
                            .frame(height: 35)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        
                        Button {
                            //                    if vm.chatText != "" {
                            vm.bedj += 1
                            
                            FirebaseAuthDatabase.sendPushNotification(to: vm.chatUser?.token ?? "", title: vm.chatCurentUser?.name ?? "", badge: "\(vm.bedj)", body: vm.chatText)
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
                    guard let toId = vm.chatUser?.uid else {return}
                    let uid = FirebaseData.shared.users.uid
                    if vm.blokUserTo {
                        FirebaseData.shared.firestore.collection("users").document(uid).collection("blokUser").document(toId).delete() { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            vm.blokUserTo = false
                        }
                        
                    } else {
                        
                        FirebaseData.shared.firestore.collection("users").document(uid).collection("blokUser").document(toId).setData([
                            "blokUser": toId
                        ]) { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    print("\(arrayUser)")
                } label: {
                    Text(vm.blokUserTo ? "Разблокировать" : "Заблокировать" )
                        .foregroundColor(vm.blokUserTo ? .blue : .red)
                }
            })
            .onDisappear {
                vm.firestoreLisener?.remove()
            }
            .sheet(isPresented: $showImagePicker, content: {
                OpenGallary(isShown: $showImagePicker, image: $image, imageBol: .constant(false), sourceType: sourceType)
            })
            
            .actionSheet(isPresented: $showSheet) {
                ActionSheet(title: Text("Загрузите фото"), message: nil, buttons: [
                    .default(Text("Галерея")) {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text("Камера")) {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    },
                    .cancel(Text("Выход"))
                ])
            }
            .onChange(of: image) { newValue in
                if newValue == newValue {
                    guard let image = image else {return}
                    guard let imageNameUid = vm.chatCurentUser?.uid else {return}
                    let photoName = ("\(imageNameUid)\(UUID())")
                    FirebaseAuthDatabase.aploadImage(photoName: photoName, photo: image, dataUrl: "chatImage") { result in
                        switch result {
                            
                        case .success(let url):
                            vm.imageMessageURL = url.absoluteString
                            vm.bedj += 1
                            vm.handleSend()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            }
            .onDisappear {
                
                vm.chatBedjIcon()
            }
            .onTapGesture {
                withAnimation {
                    popapSetings = false
                }
            }
        }
    }
}
struct MessageView: View {
    let message: ChatMessage
    @State var shareBool = false
    @State var image = ""
    var body: some View {
        VStack{
            
            HStack{
                if message.fromId == FirebaseData.shared.auth.currentUser?.uid {
                    Spacer()
                    HStack{
                        VStack(alignment: .trailing, spacing: 3){
                            HStack{
                                
                                if message.image != "" {
                                    Button {
                                        image = message.image
                                        shareBool = true
                                    } label: {
                                        
                                        WebImage(url: URL(string: message.image))
                                            .onSuccess { image, data, cacheType in
                                                
                                            }
                                            .resizable()
                                            .placeholder(Image(systemName: "photo")) // Placeholder Image
                                        // Supports ViewBuilder as well
                                            .placeholder {
                                                Rectangle().foregroundColor(.gray)
                                            }
                                            .indicator(.activity) // Activity Indicator
                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                            .scaledToFill()
                                            .frame(maxWidth: 150, maxHeight: 150)
                                            .cornerRadius(10)
                                            .clipped()
                                    }
                                } else {
                                    
                                    Text(message.text)
                                        .foregroundColor(.black)
                                    
                                }
                            }
                            .padding(message.image != "" ? 0 : 10)
                            .background(colorApp)
                            .cornerRadius(8)
                            HStack(spacing: 0){
                                Text(message.date.dateValue(), style: .date)
                                Text(message.date.dateValue(), style: .time)
                            }.font(.system(size: 8)).foregroundColor(.gray)
                            
                        }
                    }
                    
                } else {
                    HStack{
                        VStack(alignment: .leading, spacing: 3){
                            
                            HStack{
                                if message.image != "" {
                                    Button {
                                        image = message.image
                                        shareBool = true
                                    } label: {
                                        
                                        WebImage(url: URL(string: message.image))
                                            .onSuccess { image, data, cacheType in
                                                
                                            }
                                            .resizable()
                                            .placeholder(Image(systemName: "photo")) // Placeholder Image
                                        // Supports ViewBuilder as well
                                            .placeholder {
                                                Rectangle().foregroundColor(.gray)
                                            }
                                            .indicator(.activity) // Activity Indicator
                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                            .scaledToFill()
                                            .frame(maxWidth: 150, maxHeight: 150)
                                            .cornerRadius(10)
                                            .clipped()
                                    }
                                } else {
                                    Text(message.text)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(message.image != "" ? 0 : 10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
//                            Spacer()
                            HStack(spacing: 0){
                                Text(message.date.dateValue(), style: .date)
                                Text(message.date.dateValue(), style: .time)
                            }.font(.system(size: 8)).foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                
            }
            
            
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .sheet(isPresented: $shareBool) {
            PresentImage(imageUrl: $image)
        }
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

