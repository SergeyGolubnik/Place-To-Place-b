//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit


struct PlaceDetals: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: PlaceDetalsViewModel
    // Chat
    @State var chatUser: ChatUsers?
    @StateObject var vw = MainMessagesViewModel()
    @StateObject var dataMap = MapViewModelPresent()
    @StateObject var data = FirebaseData()
    @State var placeDetailViewModel = PlaceDetalsViewModel(places: nil)
    
    var chatLogViewModel = ChatLogViewModel(chatUser: nil, chatCurentUser: nil)
    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100, maximum: 100)), count: 2)
    
    
    
    
    var body: some View {
        
        ZStack {
            colorApp
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack{
                        
                        Capsule()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 60, height: 12, alignment: .center)
                            .padding(.vertical)
                    }
                    
                    HStack{
                        Text(vm.name)
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.leading)
                        
                        Spacer()
                        if vm.userId == vm.user!.uid {
                            Button(action: {
                                vm.redactPlace.toggle()
                            }) {
                                Text("Изменить")
                                
                            }
                            .padding(.trailing)
                        } else {
                            if vm.myFavorit == "" {
                                Button(action: {
                                    if vm.user!.uid != "", vm.userId != "" {
                                        var newFavorit =  [String]()
                                        if vm.favorit == [] {
                                            vm.favorit = [vm.user!.uid]
                                            newFavorit = vm.favorit
                                        } else {
                                            vm.favorit.append(vm.user!.uid)
                                            newFavorit = vm.favorit
                                        }
                                        FirebaseAuthDatabase.updateFavorit(key: vm.key, favorit: newFavorit, ref: FirebaseData.shared.ref) { resalt in
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
                    HStack{
                        VStack{
                            
                            if !vm.moderation {
                                Text("Точка на модерации")
                                    .foregroundColor(.red)
                            }
                            if vm.updatePlaceNew {
                                Text("Ваша точка изменена\nОбновите страницу")
                                    .foregroundColor(.red)
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
                                    vm.imagePresent = vm.imageUrl
                                    vm.shareBool = true
                                } label: {
                                    HStack {
                                        WebImage(url: URL(string: vm.imageUrl))
                                            .resizable()
                                            .placeholder(Image(systemName: "photo")) // Placeholder Image
                                        // Supports ViewBuilder as well
                                            .placeholder {
                                                Rectangle().foregroundColor(.gray)
                                            }
                                            .indicator(.activity) // Activity Indicator
                                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                            .scaledToFill()
                                            .frame(width: 210, height: 210)
                                            .cornerRadius(15)
                                            .clipped()
                                    }
                                    .padding(.leading, 30)
                                    
                                }
                                
                                if vm.imageGellery != [] {
                                    HStack{
                                        
                                        
                                        LazyHGrid(rows: columns) {
                                            
                                            ForEach(vm.imageGellery, id: \.self) { image in
                                                Button{
                                                    vm.imagePresent = image
                                                    vm.shareBool = true
                                                } label: {
                                                    WebImage(url: URL(string: image))
                                                        .resizable()
                                                        .placeholder(Image(systemName: "photo")) // Placeholder Image
                                                    // Supports ViewBuilder as well
                                                        .placeholder {
                                                            Rectangle().foregroundColor(.gray)
                                                        }
                                                        .indicator(.activity) // Activity Indicator
                                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(15)
                                                        .clipped()
                                                    
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
                            if vm.message, vm.userPlace.uid != vm.user!.uid {
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
                                placeDetailViewModel.places = vm.places
                                placeDetailViewModel.user = vm.user
                                placeDetailViewModel.userAll = vm.userAll
                                vm.userPlaceBool.toggle()
                            }) {
                                WebImage(url: URL(string: vm.avatarNikPlace))
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .padding(.leading)
                                Text(vm.nikNamePlace)
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
                            if vm.typeName != "" {
                                Image(vm.typeName)
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
                                if vm.location != "" {
                                    HStack {
                                        Text(vm.location)
                                            .padding(.trailing)
                                        
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    if vm.discription != "" {
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
                                Text(vm.discription)
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
                    VStack{
                        if vm.user?.uid == "swjITaC8zPZ5rjdML7LZftuaZCi1"{
                            
                            Button(action: {
                                vm.moderation = true
                                vm.moderationPlace()
                                let uid = FirebaseData.shared.auth.currentUser?.uid == vm.user!.uid ? vm.userPlace.uid : vm.user!.uid
                                self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                self.chatLogViewModel.chatUser = self.chatUser
                                self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                self.chatLogViewModel.fetchMessage()
                                vm.messageBool.toggle()
                            }) {
                                Text("Модерация пройдена")
                            }.padding(10)
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.leading, 20)
                            Button(action: {
                                vm.moderation = false
                                vm.moderationPlace()
                                let uid = FirebaseData.shared.auth.currentUser?.uid == vm.user!.uid ? vm.userPlace.uid : vm.user!.uid
                                self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                self.chatLogViewModel.chatUser = self.chatUser
                                self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                self.chatLogViewModel.fetchMessage()
                                vm.messageBool.toggle()
                            }) {
                                Text("Модерация не пройдена")
                            }.padding(10)
                                .font(.title3)
                                .foregroundColor(.red)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.leading, 20)
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .onAppear{
            DispatchQueue.main.async {
                vm.getData()
                vm.starsRating()
                vm.comentPlace()
                
            }
            
        }
        
        .fullScreenCover(isPresented: $vm.messageBool) {
            ChatLogView(vm: chatLogViewModel)
        }
        .fullScreenCover(isPresented: $vm.userPlaceBool) {
            dismiss()
        } content: {
            FavoritList(placeDetailViewModel: $placeDetailViewModel, title: vm.places?.name ?? "", place: data.places)
        }
        .sheet(isPresented: $vm.starsBool) {
            StarsRatingView(placeModel: vm.places, userPlace: vm.userPlace, starsBoolView: $vm.starsBool)
        }
        .sheet(isPresented: $vm.redactPlace) {
            dismissNewPlace()
        } content: {
            NewPlaceView(mv: ModelNewPlaceView(place: vm.places))
        }
        .sheet(isPresented: $vm.shareBool) {
            PresentImage(imageUrl: $vm.imagePresent)
        }
        .actionSheet(isPresented: $vm.navigationBool) {
            ActionSheet(title: Text("Построить маршрут"), message: nil, buttons: [
                .default(Text("Apple")) {
                    let lanchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsMapSpanKey]
                    vm.places?.mapItem?.openInMaps(launchOptions: lanchOption)
                },
                .default(Text("Yandex")) {
                    guard let longitude = Float((vm.places?.longitude) ?? "") else {return}
                    guard let latitude = Float((vm.places?.latitude) ?? "") else {return}
                    guard let urlYandex = URL(string: "yandexnavi://build_route_on_map/?lat_to=\(latitude)&lon_to=\(longitude)") else {return}
                    if UIApplication.shared.canOpenURL(urlYandex) {
                        UIApplication.shared.open(urlYandex, options: [:])
                    }
                },
                .cancel(Text("Выход"))
            ])
        }
    }
    
    
    func dismiss() {
        vm.places = placeDetailViewModel.places
        vm.getData()
    }
    func dismissNewPlace() {
        vm.updatePlaceNew = true
        vm.getData()
    }
    
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        let place = PlaceModel(userId: "", name: "Тест", key: "", nikNamePlace: "",avatarNikPlace: "", phoneNumber: "", phoneNumberArray: nil, location: "Мсква  ул Правды 27с7", type: "Бары и пабы", typeName: "18+", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: false, moderation: false)
        
        
        let placeDetailViewModel = PlaceDetalsViewModel(places: place)
        PlaceDetals(vm: placeDetailViewModel)
    }
}
