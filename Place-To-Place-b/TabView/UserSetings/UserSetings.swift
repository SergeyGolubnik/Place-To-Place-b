//
//  UserSetings.swift
//  Place-To-Place-b
//
//  Created by СОВА on 05.10.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct UserSetings: View {
    @Environment(\.presentationMode) var presentationMode
    @State var placeDetailViewModel = PlaceDetalsViewModel(places: nil, user: nil, userAll: nil)
    @State var title = "Все"
    @State var placeMy = false
    @State var supportBooll = false
    @State var place = [PlaceModel]()
    @Binding var user: Users
    @Binding var exitBool: Bool
    @State var alertDelete = false
    @State var showImagePicker: Bool = false
    @State var imageURL = ""
    @State var image = UIImage(named: "avatar-1")
    @State var showSheet: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @StateObject var vw = MainMessagesViewModel()
    @State var chatUser: ChatUsers?
    var chatLogViewModel = ChatLogViewModel(chatUser: nil, chatCurentUser: nil)
    
    var body: some View {
        NavigationView {
            
            VStack{
                VStack{
                    WebImage(url: URL(string: imageURL))
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
                        .frame(width: 150, height: 150)
                        .cornerRadius(150)
                        .clipped()
                    Button {
                        showSheet = true
                    } label: {
                        Text("Изменить")
                    }
                    
                }.padding()
                VStack{
                    Button {
                        self.placeMy = true
                    } label: {
                        HStack{
                            Text("Ваши места")
                                .padding()
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(width: 320, height: 30)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            exitBool = true
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }) {
                        HStack{
                            
                            Text("Выход")
                                .padding()
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .frame(width: 320, height: 30)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .padding(.top, 50)
                    
                    Button {
                        self.alertDelete = true
                    } label: {
                        HStack{
                            Text("Выйти и удалить")
                                .padding()
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .frame(width: 320, height: 30)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    Button {
                        let uid = supportUid
                        self.chatUser = ChatUsers(name: supportName, uid: uid, phoneNumber: supportPhone, profileImage: supportPhoto, token: "")
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                        self.chatLogViewModel.fetchMessage()
                        self.supportBooll = true
                    } label: {
                        HStack{
                            Text("Написать в техпотдержку")
                                .padding()
                            Spacer()
                        }
                        .foregroundColor(.blue)
                        .frame(width: 320, height: 30)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                Spacer()
            }
            
            .navigationBarColor(uiColorApp)
            .navigationBarTitle(user.lastName ?? "",displayMode: .inline)
            .onAppear {
                imageURL = user.avatarsURL ?? ""
            }
            .fullScreenCover(isPresented: $placeMy) {
                dismiss()
            } content: {
                FavoritList(placeDetailViewModel: $placeDetailViewModel, title: title, place: place)
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
            .fullScreenCover(isPresented: $supportBooll) {
                ChatLogView(vm: chatLogViewModel)
            }
            .onChange(of: image, perform: { newValue in
                if newValue == newValue {
                    FirebaseAuthDatabase.updateAvatarImage(user: user, image: newValue!) { result in
                        switch result {
                            
                        case .success(let url):
                            imageURL = url.absoluteString
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            })
            .alert(isPresented: $alertDelete) {
                Alert(title: Text("Выйти и удалить"), message: Text("Удаления аккаунта и выход. Вы не сможете его востоновить"), primaryButton: .cancel(Text("Выйти")), secondaryButton: .default(Text("Ok"), action: {
                    let user = Auth.auth().currentUser
                    
                    user?.delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            exitBool = true
                        }
                    }
                }))
            }
            .background(Color(.init(gray: 0.7, alpha: 0.19)))
            .ignoresSafeArea(edges: .bottom)
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct UserSetings_Previews: PreviewProvider {
    static var previews: some View {
        UserSetings(user: .constant(Users(lastName: "Sergey", email: "sergey8282@list.ru", avatarsURL: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/avatars%2FxWqXJkftXjZKlf1JCBHY1dkvdPN2?alt=media&token=45dc9b14-f65d-44e5-9d90-6867faa419ae", uid: "12343234", deviseToken: "ewtv4t", phoneNumber: "+79773448064")), exitBool: .constant(false))
    }
}

