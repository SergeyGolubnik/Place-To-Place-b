//
//  ListPlace.swift
//  Place-To-Place
//
//  Created by СОВА on 27.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListPlace: View {
    
    @StateObject var data = FirebaseData()
    
    
    @State var detailBool = false
    @Binding var placeDetailViewModel: PlaceDetalsViewModel
    @Binding var filter: String
    @State var placeF = [PlaceModel]()
    var body: some View {
        GeometryReader{ gometry in
            
            VStack{
                
                ScrollView(showsIndicators: false) {
                    LazyVStack{
                        ForEach(placeF, id: \.id) {plac in
                            VStack{
                                HStack {
                                    WebImage(url: URL(string: plac.avatarNikPlace))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipped()
                                        .cornerRadius(30)
                                        .overlay(RoundedRectangle(cornerRadius: 30)
                                                    .stroke(Color(.label), lineWidth: 1)
                                        )
                                        .shadow(radius: 5)
                                    Text(plac.nikNamePlace)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Spacer()
                                }.padding(.horizontal,5)
                                    .padding(.top)
                                ScrollView(.horizontal){
                                    HStack{
                                        
                                        WebImage(url: URL(string: plac.imageUrl ?? ""))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: gometry.size.width - 40, height: gometry.size.height / 3)
                                            .clipped()
                                        if plac.gellery != nil, plac.gellery != [] {
                                            
                                            ForEach(plac.gellery ?? [""], id: \.self) { i in
                                                WebImage(url: URL(string: i ))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: gometry.size.width - 40, height: gometry.size.height / 3)
                                                    .clipped()
                                            }
                                        }
                                    }
                                }
                                VStack {
                                    HStack{
                                        Text(plac.name!)
                                            .font(.title2)
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        let rating = starsRating(placeRating: plac.rating ?? ["": 0])
                                        ForEach(1...5, id: \.self) {index in
                                            Image(index <= Int(rating) ? "filledStar" : "emptyStar")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.orange)
                                            
                                        }
                                    }
                                    HStack{
                                        
                                        Text(plac.discription ?? "")
                                            .font(.caption)
                                        
                                            .lineLimit(2)
                                        Spacer()
                                        Button {
                                            detailBool.toggle()
                                            placeDetailViewModel.places = plac
                                        } label: {
                                            VStack{
                                                Spacer()
                                                Text("Подробней")
                                            }.padding(.bottom, 3)
                                        }
                                        
                                    }
                                    Divider()
                                }.padding(.horizontal,5)
                            }
                            
                        }
                    }
                }
            }.padding(.horizontal, 30)
            
        }
        
            .onChange(of: filter) { value in
                placeF = data.places
                if value == filter, value != data.users.uid, filter != "" {
                    placeF = data.places.filter {$0.type == filter}
                } else if value == data.user.uid, filter != "" {
                    placeF = data.places.filter {$0.userId == filter}
                } else {
                    placeF = data.places
                }
            }
            .onChange(of: data.places, perform: { newValue in
                if data.places == newValue, filter == "" {
                    placeF = data.places
                }

            })
        .sheet(isPresented: $detailBool, content: {
            PlaceDetals(vm: placeDetailViewModel)
        })
    }
    private func starsRating(placeRating: [String: Int]) -> Double {
        var ratingDouble = ""
        var resalt = 0.0
        var starsSumm = 0
        var starsEnty = 0
        for i in placeRating {
            starsSumm += i.value
            starsEnty += 1
        }
        resalt = Double(starsSumm) / Double(starsEnty)
        if resalt != 0.0 {
            ratingDouble = String(format: "%.1f", resalt)
        }
        return Double(ratingDouble) ?? 0.0
    }
}

struct ListPlace_Previews: PreviewProvider {
    static var previews: some View {
        let place = PlaceModel(userId: "", name: "Тест", key: "", nikNamePlace: "",avatarNikPlace: "", phoneNumber: "", phoneNumberArray: nil, location: "Мсква  ул Правды 27с7", type: "Бары и пабы", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: false, moderation: false)
        
        ListPlace(placeDetailViewModel: .constant(PlaceDetalsViewModel(places: place)), filter: .constant(""))
    }
}
