//
//  PageView3.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct PageViev3: View {
    
    var body: some View {
        ZStack {
            Color.hex("FEE086")
                        .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
             
                Text("Вы можете добавлять ваши любимые места, размещать объявления привязывая их к геолокации и без.")
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

struct PageViev3_Previews: PreviewProvider {
    static var previews: some View {
        PageViev3()
    }
}
