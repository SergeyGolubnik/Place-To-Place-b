//
//  AnnatatonPin.swift
//  Place-To-Place
//
//  Created by СОВА on 14.03.2022.
//

import SwiftUI

struct AnnatatonPin: View {
   
    @StateObject var category = Category()
    @State var image: String
    var body: some View {
            
            ZStack{
                Triangle()
                    .foregroundColor(colorApp)
                    .offset(y: 35)
                    .frame(width: 50, height: 50, alignment: .center)
                Circle()
                    .frame(width: 52, height: 52)
                Circle()
                    .foregroundColor(colorApp)
                    .frame(width: 50, height: 60)
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
            }
            
            
            
        .shadow(radius: 3)
    }
}

struct AnnatatonPin_Previews: PreviewProvider {
    static var previews: some View {
        
        AnnatatonPin(image: "kinder")
    }
}
struct Triangle : Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}


