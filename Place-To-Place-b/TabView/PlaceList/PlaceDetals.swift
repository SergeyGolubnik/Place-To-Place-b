//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @Binding var place: PlaceModel
    @State var updateView = false
    @State var redactPlace = false
    @State var messageBool = false
    @State var navigationBool = false
    @State var myFavorit = ""
    @State var starsBool = false
    @State var stars = "-"
    @State var coment = [String]()
    @State var user: Users
    @State var userPlace: Users!
    @State var userPlaceBool = false
    @State var type = ""
    @State var avatar = ""
    @State var favoritPlaceBool = false
    let category: [CategoryModel] = [
        CategoryModel(imageString: "bar", name: "Бары и пабы"),
        CategoryModel(imageString: "restoran", name: "Рестораны и кафе"),
        CategoryModel(imageString: "fasfud", name: "Фасфуд"),
        CategoryModel(imageString: "salon", name: "Красота"),
        CategoryModel(imageString: "marcet", name: "Магазины"),
        CategoryModel(imageString: "tc", name: "Торговые центры"),
        CategoryModel(imageString: "kinder", name: "Для детей"),
        CategoryModel(imageString: "hotel", name: "Гостиницы"),
        CategoryModel(imageString: "bisnes", name: "Бизнес"),
        CategoryModel(imageString: "dicovery", name: "Места культуры"),
        CategoryModel(imageString: "parc", name: "Парки и скверы"),
        CategoryModel(imageString: "razvlechenia", name: "Развлечения"),
        CategoryModel(imageString: "servis", name: "Сервис"),
        CategoryModel(imageString: "servisAuto", name: "Автосервис"),
        CategoryModel(imageString: "direct", name: "Объявления"),
        CategoryModel(imageString: "adalt", name: "Для взрослых"),
        CategoryModel(imageString: "tinder", name: "Для общения")
    ]
    @State var placeModel = PlaceModel(
        userId: "10101010111",
        name: "Kreml",
        key: "100000001",
        location: "Москва, Красная пffffffffffffffffffffffffff ffff fffff fffff ffff лощад",
        type: "bar",
        rating: ["10101010111": 1, "1013401010111": 5, "101010124540111": 3],
        imageUrl: "https://avatars.mds.yandex.net/get-zen_doc/3512190/pub_600f1c978dfe7b3b2dd841cc_600f235527add74df605f5de/scale_1200",
        latitude: "22222222",
        deviseToken: "10101010101010101010",
        longitude: "111111111",
        discription: "Центр москвы и всей Руси",
        switchPlace: "Делится",
        gellery: ["https://www.funomania.ru/uploads/posts/2021-06/1623987922_1600745655_7-p-koreyanki-9.jpg","https://im0-tub-ru.yandex.net/i?id=0fcb4ce76e51714887776490ee0316c3&ref=rim&n=33&w=450&h=300","https://shop.salonsecret.ru/media/setka_editor/post/3-2_2.jpg","https://volosyinform.ru/wp-content/uploads/2020/10/pochemu-ryzhij-cvet-volos.jpg","https://i1.wp.com/avrorra.com/wp-content/uploads/2016/05/ryzhie_volosy_-30.jpg","https://i1.wp.com/avrorra.com/wp-content/uploads/2016/05/ryzhie_volosy_-1.png","https://i.redd.it/7hrcxl42kcwz.jpg"],
        favorit: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1","DDQMzZ33WKQSK9CRXyzndKSPf7s2"],
        date: "2021-08-05 11:04:58"
    )
    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100, maximum: 100)), count: 2)
    
    
    
    
    var body: some View {
        
        ZStack {
            Color.hex("FEE086")
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    VStack {
                        Capsule()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 60, height: 12, alignment: .center)
                            .padding(.vertical)
                        HStack{
                            if place.name != "", place.name != nil {
                                Text(place.name!)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .padding(.leading)
                            }
                            Spacer()
                            if place.userId == user.uid {
                                Button(action: {
                                    self.redactPlace.toggle()
                                }) {
                                    Text("Изменить")
                                    
                                }
                                .padding(.trailing)
                            } else {
                                if myFavorit == "" {
                                    Button(action: {
                                        if user.uid != "", place.userId != "" {
                                            var newFavorit =  [String]()
                                            if place.favorit == nil {
                                                place.favorit = [user.uid]
                                                newFavorit = place.favorit!
                                            } else {
                                                place.favorit?.append(user.uid)
                                                newFavorit = place.favorit!
                                            }
                                            FirebaseAuthDatabase.updateFavorit(key: place.key, favorit: newFavorit, ref: FirebaseData.shared.ref) { resalt in
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
                                            Text("Добавить в\nизбранное")
                                        }
                                        
                                        
                                    }
                                    .padding(.trailing)
                                }
                                
                            }
                            
                        }
                        Divider().foregroundColor(.black)
                    }
                    
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                if place.imageUrl != "",place.imageUrl != nil {
                                    HStack {
                                        UrlImageView(urlString: place.imageUrl, wight: 210, height: 210)
                                        
                                    }
                                    .padding(.leading, 30)
                                }
                                if place.gellery != nil, place.gellery != [] {
                                    HStack{
                                        
                                        
                                        LazyHGrid(rows: columns) {
                                            ForEach(place.gellery!, id: \.self) { image in
                                                UrlImageView(urlString: image, wight: 100, height: 100)
                                                
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
                            Button(action: {
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
                            
                            if avatar != "" {
                                Button(action: {
                                    userPlaceBool.toggle()
                                }) {
                                    UrlImageView(urlString: avatar, wight: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding(.leading)
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
                            Text(stars)
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
                            if type != "" {
                                Image(type)
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
                                if place.location != nil, place.location != "" {
                                    HStack {
                                        Text(place.location!)
                                            .padding(.trailing)
                                        
                                    }
                                }
                                
                            }
                        }
                        .padding(.top)
                        
                    }
                    if place.discription != "", place.discription != nil {
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
                                Text(place.discription!)
                                    .lineLimit(10)
                                    .padding(.top)
                                Spacer()
                            }
                            .padding([.leading,.trailing])
                        }
                    }
                    if coment != [String]() {
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
                            ForEach(coment, id: \.self) { index in
                                HStack {
                                    Text(index)
                                        .padding(5)
                                        .background(Color.hex("CDB56C"))
                                        .cornerRadius(10)
                                        .padding(.top)
                                    Spacer()
                                }
                                .padding([.leading,.trailing])
                                Divider().padding(.trailing,70)
                            }
                            
                        }
                    }
                    Spacer()
                    
                }
            }
            
            
            
        }
        .onAppear {
            
            

            if place.userId != "" {
                FirebaseData.shared.getFrendUserData(userId: place.userId) { resalt in
                    
                    switch resalt {
                        
                    case .success(let userPlace):
                        self.userPlace = userPlace
                        if userPlace.avatarsURL != nil {
                            self.avatar = userPlace.avatarsURL!
                        }
                        print(userPlace)
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            }
            if place.userId == "" {
                self.place = placeModel
            }
            if place.type != "" {
                for i in category {
                    if i.name == place.type {
                        self.type = i.imageString!
                    }
                }
            }
            if place.favorit != [], place.favorit != nil {
                for i in place.favorit! {
                    if i == user.uid {
                        self.myFavorit = i
                    }
                }
            }
            comentPlace()
            starsRating()
        }
        .sheet(isPresented: $starsBool) {
            StarsRatingView(placeModel: place, userPlace: userPlace, starsBoolView: $starsBool)
        }
    }
    
    
    
    private func comentPlace() {
        self.coment.removeAll()
        if place.coments != nil {
            
            var com = [String]()
            for ( _ , valuesComent) in place.coments! {
                com.append(valuesComent)
            }
            self.coment = com
        }
    }
    private func starsRating() {
        if place.rating != nil {
            var resalt = 0.0
            var starsSumm = 0
            var starsEnty = 0
            guard let rating = place.rating else {return}
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
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}
