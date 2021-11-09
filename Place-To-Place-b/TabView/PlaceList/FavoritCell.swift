//
//  FavoritCell.swift
//  Place-To-Place-b
//
//  Created by СОВА on 01.11.2021.
//

import SwiftUI

struct FavoritCell: View {
    @State var imageURL = ""
    @State var name = "Бар Ресторан дрова и угли"
    @State var location = "Москва, Большая одинокая ордынка д12 "
    @State var rating = 3
    @State var type = "Парки и скверы"
    @State var typeString = "bar"
    @State var categoryArray = Category()
    @State var placeRating: [String: Int]?
   
    var body: some View {
        ZStack{
            HStack(spacing: 0){
                VStack{
                    UrlImageView(urlString: imageURL, wight: 110, height: 110)
                        .cornerRadius(4)
                        .shadow(radius: 5)
//                        .padding()
                    Spacer()
                }
                
                VStack(spacing: 0){
                    HStack{
                        Text(name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.top,5)
                        Spacer()
                    }
                    HStack{
                        Text(location)
                            .lineLimit(2)
                            .font(Font.system(size: 12))
                            .frame(maxHeight: 30)
                        Spacer()
                    }
                    HStack{
                        Image(typeString)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                        Spacer()
                        if rating != 0 {
                            HStack{
                                ForEach(1...5, id: \.self) {index in
                                    Image(index <= rating ? "filledStar" : "emptyStar")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.orange)
                                        
                                }
                            }
                        }
                        
                    }

                    Spacer()
                }.padding(.leading)
                Spacer()
                
            }
            .padding(.top, 10)
            .onAppear(perform: {
                starsRating()
                if type != "" {
                    for i in categoryArray.categoryArray {
                        if i.name == type {
                            self.typeString = i.imageString!
                        }
                    }
                }
            })
            
//            .frame(height: 130)
//            .background(LinearGradient(gradient: Gradient(colors: [Color.hex("ffffff"), Color.hex("ffffff")]), startPoint: .top, endPoint: .bottom))
//            
//            .cornerRadius(10)
//            .padding(.horizontal,10)
//            
//            .shadow(radius: 5)
        }
        
    }
    private func starsRating() {
        if placeRating != nil {
            var resalt = 0.0
            var starsSumm = 0
            var starsEnty = 0
        guard let ratingArray = placeRating else {return}
            for i in ratingArray {
                starsSumm += i.value
                starsEnty += 1
            }
            resalt = Double(starsSumm) / Double(starsEnty)
            if resalt != 0.0 {
                self.rating = Int(resalt)
            }

        }

    }
}

struct FavoritCell_Previews: PreviewProvider {
    static var previews: some View {
        FavoritCell()
    }
}
