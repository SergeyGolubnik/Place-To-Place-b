//
//  StarsRatingView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 28.09.2021.
//

import SwiftUI

struct StarsRatingView: View {
    @Binding var starsBoolView: Bool
    @State private var rating: Int?
    @State var comets = ""
    private func starsType(index: Int) -> String {
        if let rating = rating {
            return index <= rating ? "filledStar" : "emptyStar"
        } else {
            return "emptyStar"
        }
    }
    var body: some View {
        VStack{
            HStack{
                Text("Оцените место")
                    .font(.title)
                    .padding()
            }
            HStack{
                ForEach(1...5, id: \.self) {index in
                    Image(self.starsType(index: index))
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            self.rating = index
                        }
                }
            }
            VStack{
                HStack{
                    TextEditor(text: $comets)
                        .cornerRadius(5)
                        .padding()
                        .frame(height: 200)
                        
                }
                .shadow(radius: 3)
                Button(action: {
                    starsBoolView = false
                }) {
                    Text("Сщхранить")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                    
                }
            }
            .background(Color.clear)
        }
        
        
    }
}

struct StarsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StarsRatingView(starsBoolView: .constant(false))
    }
}
