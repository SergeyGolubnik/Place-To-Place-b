//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI


class PlaceDetalsViewModel: ObservableObject {
//    @StateObject var data = FirebaseData()
    @Published var myFavorit = ""
    @Published var stars = "-"
    @Published var comentArray = [Comment]()
    @Published var imageGeneral = UIImage()
    @Published var imageGellery = [UIImage]()
    @Published var isLoading = true
    @Published var userPlace: Users!
    @Published var avatar = UIImage(named: "place-to-place-banner")
    @Published var userNik = ""
    @Published var categoryArray = Category()
    @Published var type = ""
    var places: PlaceModel?
    var user: Users?
    var userAll: [Users]?
    
    init(places: PlaceModel?, user: Users?, userAll: [Users]?) {
        self.user = user
        self.places = places
        self.userAll = userAll
        print("_______________________\(self.places?.imageUrl)")
        getData()
        starsRating()
        comentPlace()
        imagePhoto()
    }
    private func starsRating() {
        guard let places = places else { return }
        if places.rating != nil {
            var resalt = 0.0
            var starsSumm = 0
            var starsEnty = 0
            guard let rating = places.rating else {return}
            for i in rating {
                starsSumm += i.value
                starsEnty += 1
            }
            resalt = Double(starsSumm) / Double(starsEnty)
            if resalt != 0.0 {
                self.stars = String(format: "%.1f", resalt)
            }
        }
    }
    private func comentPlace() {
        guard let place = places else {
            return
        }
        comentArray.removeAll()
        if place.coments != nil {
            var arrayCom = [Comment]()
            for (keyCom, valuesComent) in place.coments! {
                guard let userAll = userAll else {
                    return
                }

                for user1 in userAll {
                    
                    if user1.uid == keyCom {
                        var stars = 0
                        if place.rating != nil {
                            for (keyStars, stars1) in place.rating! {
                                if keyStars == keyCom {
                                    stars = stars1
                                }
                            }
                        }
                        
                        let comment = Comment(userName: user1.lastName ?? "", userUid: keyCom, avatarImage: FirebaseData.shared.getImageUIImage(url: user1.avatarsURL ?? ""), comment: valuesComent, stars: stars)
                        arrayCom.append(comment)
                    }
                }
            }
            comentArray = arrayCom
        }
        
    }
    private func imagePhoto() {
        print("imagePhoto \(places?.imageUrl)")
        DispatchQueue.main.async {
            guard let place = self.places else {
                return
            }
            guard let imageUrl = place.imageUrl else {return
                self.imageGeneral = UIImage(named: "no_image")!
            }
            self.imageGeneral = FirebaseData.shared.getImageUIImage(url: imageUrl)
            
            if place.gellery != nil, place.gellery != [] {
                for imageStringUrl in place.gellery! {
                    self.imageGellery.append(FirebaseData.shared.getImageUIImage(url: imageStringUrl))
                }
            }
            self.isLoading = false
        }
    }
    private func getData() {
        guard let places = places else {
            return
        }

        if places.userId != "" {
            //                FirebaseData.shared.getFrendUserData(userId: place.userId) { resalt in
            //
            //                    switch resalt {
            //
            //                    case .success(let userPlace):
            //                        self.userPlace = userPlace
            
            //
            //                    case .failure(let error):
            //                        print(error.localizedDescription)
            //                        return
            //                    }
            //                }
            guard let userAll = userAll else {
                return
            }

            for placeUser in userAll {
                if places.userId == placeUser.uid {
                    print(placeUser)
                    self.userPlace = placeUser
                    if let avatarURL = userPlace.avatarsURL {
                        self.avatar = FirebaseData.shared.getImageUIImage(url: avatarURL)
                    }
                    if let nik = userPlace.lastName {
                        self.userNik = nik
                    }
                }
            }
            
        }
        if places.type != "" {
            for i in categoryArray.categoryArray {
                if i.name == places.type {
                    self.type = i.imageString!
                }
            }
        }
        guard let user = user else {
            return
        }

        if places.favorit != [], places.favorit != nil {
            for i in places.favorit! {
                if i == user.uid {
                    self.myFavorit = i
                }
            }
        }
        
        
    }
    
}


struct PlaceDetals: View {
    @ObservedObject var vm: PlaceDetalsViewModel
    @StateObject var data = FirebaseData()
//    @Binding var place: PlaceModel
    @State var redactPlace = false
    @State var messageBool = false
    @State var navigationBool = false
    
    
    @State var myFavorit = ""
    @State var starsBool = false
    
    @State var coment = [String]()
    
    @State var user: Users
    
    @State var userAll = [Users]()
    @State var userPlaceBool = false
    
    
    
    @State var favoritPlaceBool = false
    
    @State var defaultImage = UIImage(named: "place-to-place-banner")
    @State var shareBool = false
    @State var imagePresent = UIImage()
    
    
    @State var itemImagePresent = [Any]()
    
    // Chat
    @State var chatUser: ChatUsers?
    @StateObject var vw = MainMessagesViewModel()
    var chatLogViewModel = ChatLogViewModel(chatUser: nil, chatCurentUser: nil)
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100, maximum: 100)), count: 2)
    
    
    
     
    var body: some View {
        
        ZStack {
            colorApp
                .ignoresSafeArea()
            
            
            VStack {
                VStack {
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.vertical)
                    HStack{
                        if vm.places!.name != "", vm.places!.name != nil {
                            Text(vm.places!.name!)
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding(.leading)
                        }
                        Spacer()
                        if vm.places!.userId == user.uid {
                            Button(action: {
                                self.redactPlace.toggle()
                            }) {
                                Text("Изменить")
                                
                            }
                            .padding(.trailing)
                        } else {
                            if myFavorit == "" {
                                Button(action: {
                                    if user.uid != "", vm.places!.userId != "" {
                                        var newFavorit =  [String]()
                                        if vm.places!.favorit == nil {
                                            vm.places!.favorit = [user.uid]
                                            newFavorit = vm.places!.favorit!
                                        } else {
                                            vm.places!.favorit?.append(user.uid)
                                            newFavorit = vm.places!.favorit!
                                        }
                                        FirebaseAuthDatabase.updateFavorit(key: vm.places!.key, favorit: newFavorit, ref: FirebaseData.shared.ref) { resalt in
                                            switch resalt {
                                                
                                            case .success():
                                                break
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                    self.favoritPlaceBool = true
                                }) {
                                    if !favoritPlaceBool {
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
                                    imagePresent = vm.imageGeneral
                                    shareBool.toggle()
                                } label: {
                                    HStack {
                                        Image(uiImage: vm.imageGeneral)
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
                                                        imagePresent = image
                                                        if imagePresent == image {
                                                            shareBool = true
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
                            if vm.places!.messageBool != nil, vm.userPlace != nil {
                                if vm.places!.messageBool ?? true, vm.userPlace.uid != user.uid {
                                    Button(action: {
                                        let uid = FirebaseData.shared.auth.currentUser?.uid == user.uid ? vm.userPlace.uid : user.uid
                                        self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                        self.chatLogViewModel.chatUser = self.chatUser
                                        self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                        self.chatLogViewModel.fetchMessage()
                                        //                                    self.shouIdNavigateToChatLogView.toggle()
                                        messageBool.toggle()
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
                                    let uid = FirebaseData.shared.auth.currentUser?.uid == user.uid ? vm.userPlace.uid : user.uid
                                    self.chatUser = ChatUsers(name: vm.userPlace.lastName ?? "", uid: uid, phoneNumber: vm.userPlace.phoneNumber ?? "", profileImage: vm.userPlace.avatarsURL ?? "", token: vm.userPlace.deviseToken ?? "")
                                    self.chatLogViewModel.chatUser = self.chatUser
                                    self.chatLogViewModel.chatCurentUser = self.vw.chatCurentUser
                                    self.chatLogViewModel.fetchMessage()
                                    //                                    self.shouIdNavigateToChatLogView.toggle()
                                    messageBool.toggle()
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
                            
                            
                            if vm.avatar != nil {
                                Button(action: {
                                    userPlaceBool.toggle()
                                }) {
                                    Image(uiImage: vm.avatar!)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .padding(.leading)
                                    Text(vm.userNik)
                                        .foregroundColor(.black)
                                        .font(.callout)
                                        .frame(width: 50)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                            Button(action: {
                                starsBool.toggle()
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
                                navigationBool.toggle()
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
                                if vm.places!.location != nil, vm.places!.location != "" {
                                    HStack {
                                        Text(vm.places!.location!)
                                            .padding(.trailing)
                                        
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    if vm.places!.discription != "", vm.places!.discription != nil {
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
                                Text(vm.places!.discription!)
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
        .fullScreenCover(isPresented: $messageBool) {
            ChatLogView(vm: chatLogViewModel)
        }
        .sheet(isPresented: $starsBool) {
            StarsRatingView(placeModel: vm.places, userPlace: vm.userPlace, starsBoolView: $starsBool)
        }
        .sheet(isPresented: $redactPlace) {
            NewPlaceView(place: vm.places)
        }
        .sheet(isPresented: $shareBool) {
            PresentImage(image: $imagePresent, item: $itemImagePresent)
        }
    }
   
    
    
   
   
}
//
//struct PlaceDetals_Previews: PreviewProvider {
//    static var previews: some View {
//        let place = PlaceModel(userId: "", name: "Тест", key: "", nikNamePlace: "",avatarNikPlace: "", phoneNumber: "", location: "Мсква  ул Правды 27с7", type: "Бары и пабы", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: false, moderation: false)
//        let user = Users(lastName: "Sergey", email: "sergey@mail.ru", avatarsURL: "https://firebasestorage.googleapis.com/v0/b/sergeygolubnik-place-to-place.appspot.com/o/avatars%2F00Klxwlx47aU7DgQN5ppKzTunkV2?alt=media&token=9b8de98e-4862-4a88-9711-3b69346b8faa", uid: "", deviseToken: "", phoneNumber: "")
//        let avatar = UIImage(named: "place-to-place-banner")
//        let placeDetailViewModel = PlaceDetalsViewModel(places: place, user: user, userAll: nil)
//        PlaceDetals(vm: placeDetailViewModel, user: user, avatar: avatar, userNik: "sergeeeey",chatUser: nil)
//    }
//}
