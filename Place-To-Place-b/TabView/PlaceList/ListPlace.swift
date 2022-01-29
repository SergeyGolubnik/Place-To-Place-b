//
//  ListPlace.swift
//  Place-To-Place
//
//  Created by СОВА on 27.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListPlace: View {
    @Binding var place: [PlaceModel]
        @Binding var detailBool: Bool
        @Binding var detailPlace: PlaceModel
    var body: some View {
        GeometryReader{ gometry in
            
            VStack{
                
                ScrollView(showsIndicators: false) {
                    LazyVStack{
                        ForEach(place, id: \.id) {plac in
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
                                            detailPlace = plac
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

//struct ListPlace_Previews: PreviewProvider {
//    static var previews: some View {
//        ListPlace()
//    }
//}
