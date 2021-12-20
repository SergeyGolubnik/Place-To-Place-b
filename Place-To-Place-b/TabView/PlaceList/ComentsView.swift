//
//  ComentsView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.12.2021.
//

import SwiftUI

struct ComentsView: View {
    
    @State var nikName = "Sergey"
    @State var image = UIImage(named: "place-to-place-banner")
    @State var coment = ""
    @State var rating: Int?
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
                
                Spacer()
                ForEach(1...5, id: \.self) {index in
                    Image(self.starsType(index: index))
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.orange)
                        
                }
                VStack(spacing: 0){
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipped()
                        .cornerRadius(10)
                    HStack{
                        Text(nikName)
                            .font(Font.system(size: 12))
                            .frame(width: 50)
                            .lineLimit(1)
                    }
                    
                }
                
            }
            HStack{
                Text(coment)
                Spacer()
            }
            
        }.padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
    }
}

struct ComentsView_Previews: PreviewProvider {
    static var previews: some View {
        ComentsView(nikName: "Sergey8282", coment: "2021-12-17 08:58:06.418937+0300 Place-To-Place-b[34834:906643] GTMSessionFetcher invoking fetch callbacks, data {length = 2330, bytes = 0x7b0a2020 22616363 6573735f 746f6b65 ... 36383032 220a7d0a }, error (null)", rating: 4)
    }
}
