//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @Binding var placeModel: PlaceModel
    @State var updateView = false
    @State var redactPlace = false
    @State var messageBool = false
    @State var navigationBool = false
    @State var starsBool = false
    @State var stars = "-"
    @State var userPlace: Users!
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
                            Text(place.name!)
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding(.leading)
                                
                            Spacer()
                            Button(action: {
                                redactPlace.toggle()
                            }) {
                                Text("Изменить")
                                
                            }
                            .padding(.trailing)
                        }
                        Divider().foregroundColor(.black)
                    }
                    
                    VStack {
                        ScrollView(.horizontal) {
                            HStack {
                                HStack {
                                    UrlImageView(urlString: place.imageUrl, wight: 210, height: 210)
                                    
                                }
                                .padding(.leading, 30)
                                HStack{
                                    if place.gellery != nil {
                                        
                                        LazyHGrid(rows: columns) {
                                            ForEach(place.gellery!, id: \.self) { image in
                                                UrlImageView(urlString: image, wight: 100, height: 100)
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                .frame(height: 210)
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
                            Image(place.type!)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.trailing)
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
                                HStack {
                                    Text(place.location!)
                                        
                                }
                            }
                        }
                        .padding(.top)
                        
                    }
                    
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
                    
                    Spacer()
                    
                }
            }
            
            
            
        }
        .onAppear {
            if place.rating != nil {
                starsRating()
            }
            FirebaseData.shared.getFrendUserData(userId: placeModel.userId) { resalt in
                switch resalt {
                    
                case .success(let userPlace):
                    self.userPlace = userPlace
                    print(userPlace)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
        
    let place = PlaceModel(
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
        
    
    func starsRating() {
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

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetals(placeModel: .constant(PlaceModel(key: "111", userId: "", switchPlace: "", deviseToken: "")))
    }
}
