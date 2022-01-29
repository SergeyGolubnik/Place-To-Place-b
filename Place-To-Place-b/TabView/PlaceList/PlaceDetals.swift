//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct PlaceDetals: View {
    @ObservedObject var vm: PlaceDetalsViewModel
    // Chat
    @State var chatUser: ChatUsers?
    @StateObject var vw = MainMessagesViewModel()
    
    
   
    
    var chatLogViewModel = ChatLogViewModel(chatUser: nil, chatCurentUser: nil)
    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100, maximum: 100)), count: 2)
    
    
    
     
    var body: some View {
        
        ZStack {
            colorApp
                .ignoresSafeArea()
            if let plase = vm.places {
                VStack {
                    VStack {
                        Capsule()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 60, height: 12, alignment: .center)
                            .padding(.vertical)
                        HStack{
                                Text(plase.name ?? "")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .padding(.leading)
                            
                            Spacer()
                            if plase.userId == vm.user!.uid {
                                Button(action: {
                                    vm.redactPlace.toggle()
                                }) {
                                    Text("Изменить")
                                    
                                }
                                .padding(.trailing)
                            } else {
                                if vm.myFavorit == "" {
                                    Button(action: {
                                        if vm.user!.uid != "", plase.userId != "" {
                                            var newFavorit =  [String]()
                                            if plase.favorit == nil {
                                                plase.favorit = [vm.user!.uid]
                                                newFavorit = plase.favorit!
                                            } else {
                                                plase.favorit?.append(vm.user!.uid)
                                                newFavorit = plase.favorit!
                                            }
                                            FirebaseAuthDatabase.updateFavorit(key: plase.key, favorit: newFavorit, ref: FirebaseData.shared.ref) { resalt in
                                                switch resalt {
                                                    
                                                case .success():
                                                    break
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                        vm.favoritPlaceBool = true
                                    }) {
                                        if !vm.favoritPlaceBool {
                                            Text("В избранное")
                                        }
                                        
                                        
                                    }
                                    .padding(.trailing)
                                }
                                
                            }
                            
                        }
                        Divider().foregroundColor(.black)
                    }
                    ScrollView {
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    Button {
                                        vm.imagePresent = vm.imageGeneral
                                        vm.shareBool.toggle()
                                    } label: {
                                        HStack {
                                            WebImage(url: URL(string: plase.imageUrl ?? ""))
                                            //                                        Image(uiImage: vm.imageGeneral)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 210, height: 210)
                                                .clipped()
                                                .cornerRadius(15)
                                                .overlay (
                                                    ZStack {
                                                        if vm.isLoading {
                                                            Color.black
                                                                .opacity(0.25)
                                                            
                                                            ProgressView()
                                                                .font(.title2)
                                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                .cornerRadius(12)
                                                        }
                                                    })
                                        }
                                        .padding(.leading, 30)
                                        
                                    }
                                    if vm.imageGellery != [] {
                                        HStack{
                                            
                                            
                                            LazyHGrid(rows: columns) {
                                                ForEach(vm.imageGellery, id: \.self) { image in
                                                    
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipped()
                                                        .cornerRadius(15)
                                                        .onTapGesture {
                                                            vm.imagePresent = image
                                                            if vm.imagePresent == image {
                                                                vm.shareBool = true
                                                            }
                                                            
                                                        }
                                                }
                                            }
                                            
                                        }
                                        .frame(height: 210)
                                    }
                                    
                                }
                                Divider().foregroundColor(.black)
                            }
                        }
                        VStack {
                            
                            
                            HStack {
                                if plase.messageBool != nil, vm.userPlace != nil {
                                    if plase.messageBool ?? true, vm.userPlace.uid != vm.user!.uid {
                                        Button(action: {
                                            let uid = FirebaseData.shared.auth.currentUser?.uid == vm.user!.uid ? vm.userPlace.uid : vm.user!.uid
                                            self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                            self.chatLogViewModel.chatUser = self.chatUser
                                            self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                            self.chatLogViewModel.fetchMessage()
                                            //                                    self.shouIdNavigateToChatLogView.toggle()
                                            vm.messageBool.toggle()
                                        }) {
                                            Text("Написать")
                                        }.padding(10)
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .padding(.leading, 20)
                                    }
                                } else {
                                    Button(action: {
                                        let uid = FirebaseData.shared.auth.currentUser?.uid == vm.user!.uid ? vm.userPlace.uid : vm.user!.uid
                                        self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                        self.chatLogViewModel.chatUser = self.chatUser
                                        self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                        self.chatLogViewModel.fetchMessage()
                                        //                                    self.shouIdNavigateToChatLogView.toggle()
                                        vm.messageBool.toggle()
                                    }) {
                                        Text("Написать")
                                    }.padding(10)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .padding(.leading, 20)
                                }
                                
                                
                                //                            if vm.places.avatarNikPlace != nil {
                                Button(action: {
                                    vm.userPlaceBool.toggle()
                                }) {
                                    Image(uiImage: FirebaseData.shared.getImageUIImage(url: plase.avatarNikPlace))
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .padding(.leading)
                                    Text(plase.nikNamePlace)
                                        .foregroundColor(.black)
                                        .font(.callout)
                                        .frame(width: 50)
                                        .lineLimit(1)
                                }
                                //                            }
                                
                                Spacer()
                                Button(action: {
                                    vm.starsBool.toggle()
                                }) {
                                    Image("emptyStar")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                Text(vm.stars)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.trailing)
                            }
                            Divider().foregroundColor(.black)
                        }
                        VStack {
                            
                            
                            HStack {
                                Button(action: {
                                    vm.navigationBool.toggle()
                                }) {
                                    Text("Построить маршрут")
                                }.padding(10)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.leading, 20)
                                Spacer()
                                if vm.type != "" {
                                    Image(vm.type)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding(.trailing)
                                }
                            }
                        }
                        VStack {
                            Divider().foregroundColor(.black)
                            HStack {
                                Text("Подробней")
                                    .font(.title3)
                                
                                    .padding(.leading)
                                Spacer()
                            }
                            HStack {
                                VStack{
                                    HStack(alignment: .top) {
                                        Text("Адрес:")
                                            .padding(.leading)
                                    }
                                    Spacer()
                                }
                                Spacer()
                                VStack{
                                    if plase.location != nil, plase.location != "" {
                                        HStack {
                                            Text(plase.location!)
                                                .padding(.trailing)
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                        if plase.discription != "", plase.discription != nil {
                            VStack{
                                Divider().foregroundColor(.black)
                                HStack {
                                    Text("Описание:")
                                        .font(.title3)
                                        .padding(.leading)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(.top)
                            VStack{
                                
                                HStack {
                                    Text(plase.discription!)
                                        .lineLimit(10)
                                        .padding(.top)
                                    Spacer()
                                }
                                .padding([.leading,.trailing])
                            }
                        }
                        if vm.comentArray != [] {
                            VStack{
                                Divider().foregroundColor(.black)
                                HStack {
                                    Text("Коментарии:")
                                        .font(.title3)
                                        .padding(.leading)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(.top)
                            VStack{
                                ForEach(vm.comentArray, id: \.self) { index in
                                    
                                    ComentsView(nikName: index.userName, image: index.avatarImage, coment: index.comment, rating: index.stars)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $vm.messageBool) {
            ChatLogView(vm: chatLogViewModel)
        }
        .sheet(isPresented: $vm.starsBool) {
            StarsRatingView(placeModel: vm.places, userPlace: vm.userPlace, starsBoolView: $vm.starsBool)
        }
        .sheet(isPresented: $vm.redactPlace) {
            NewPlaceView(place: vm.places)
        }
        .sheet(isPresented: $vm.shareBool) {
            PresentImage(image: $vm.imagePresent, item: $vm.itemImagePresent)
        }
    }
   
    
    
   
   
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        let place = PlaceModel(userId: "", name: "Тест", key: "", nikNamePlace: "",avatarNikPlace: "", phoneNumber: "", location: "Мсква  ул Правды 27с7", type: "Бары и пабы", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: false, moderation: false)
        let user = Users(lastName: "Sergey", email: "sergey@mail.ru", avatarsURL: "https://firebasestorage.googleapis.com/v0/b/sergeygolubnik-place-to-place.appspot.com/o/avatars%2F00Klxwlx47aU7DgQN5ppKzTunkV2?alt=media&token=9b8de98e-4862-4a88-9711-3b69346b8faa", uid: "", deviseToken: "", phoneNumber: "")
        
        let placeDetailViewModel = PlaceDetalsViewModel(places: place, user: user, userAll: nil)
        PlaceDetals(vm: placeDetailViewModel)
    }
}
