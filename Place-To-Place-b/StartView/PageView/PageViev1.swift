//
//  PageViev1.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct PageViev1: View {
    
    var body: some View {
        ZStack {
            Color.hex("FEE086")
                        .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
             
                Text("Привет\nТы скачал мое приложение\nPlace-To-Place\nЗдесь скоро будет классный дизайн\nа пока я раскажу про мое приложение\nЛистай дальше")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(.horizontal)
                Spacer()
                Text("👉")
                    .font(.system(size: 100))
                Spacer()
                
            }
            
            
            
        }
        
    }
}

struct PageViev1_Previews: PreviewProvider {
    static var previews: some View {
        PageViev1()
    }
}
