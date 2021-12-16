//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @StateObject var data = FirebaseData()
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
    @State var userNik = ""
    @State var favoritPlaceBool = false
    @State var categoryArray = Category()
    @State var defaultImage = UIImage(named: "place-to-place-banner")
    @State var shareBool = false
    @State var imagePresent = UIImage(named: "no_image")

    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100, maximum: 100)), count: 2)
    
    
    
    
    var body: some View {
        
        ZStack {
            colorApp
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
                                            Text("В избранное")
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
                                    Button {
                                        shareBool.toggle()
                                        imagePresent = data.getImageUIImage(url: place.imageUrl!)
                                    } label: {
                                        HStack {
                                            UrlImageView(urlString: place.imageUrl, wight: 210, height: 210, defaultImage: defaultImage!)
                                                .cornerRadius(15)
                                            
                                        }
                                        .padding(.leading, 30)
                                    }

                                    
                                }
                                if place.gellery != nil, place.gellery != [] {
                                    HStack{
                                        
                                        
                                        LazyHGrid(rows: columns) {
                                            ForEach(place.gellery!, id: \.self) { image in
                                                Button {
                                                    shareBool.toggle()
                                                    imagePresent = data.getImageUIImage(url: image)
                                                } label: {
                                                    UrlImageView(urlString: image, wight: 100, height: 100, defaultImage: defaultImage!)
                                                        .cornerRadius(15)
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
                                    UrlImageView(urlString: avatar, wight: 40, height: 40, defaultImage: defaultImage!)
                                        .clipShape(Circle())
                                        .padding(.leading)
                                    Text(userNik)
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
                            self.userNik = userPlace.lastName!
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            }
            if place.type != "" {
                for i in categoryArray.categoryArray {
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
        .sheet(isPresented: $redactPlace) {
            NewPlaceView(place: place)
        }
        .sheet(isPresented: $shareBool) {
            PresentImage(image: imagePresent)
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
        let place = PlaceModel(userId: "", name: "Тест", key: "", location: "Мсква  ул Правды 27с7", type: "Бары и пабы", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли. Координаты являются угловыми величинами. Каноническая форма представления координат – градусы (°), минуты (′) и секунды (″). В системах GPS широко используется представление координат в градусах и десятичных минутах либо в десятичных градусах.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: true)
        let user = Users(lastName: "Sergey", email: "sergey@mail.ru", avatarsURL: "https://firebasestorage.googleapis.com/v0/b/sergeygolubnik-place-to-place.appspot.com/o/avatars%2F00Klxwlx47aU7DgQN5ppKzTunkV2?alt=media&token=9b8de98e-4862-4a88-9711-3b69346b8faa", uid: "", deviseToken: "")
        PlaceDetals(place: .constant(place), user: user, avatar: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", userNik: "sergeeeey")
    }
}
