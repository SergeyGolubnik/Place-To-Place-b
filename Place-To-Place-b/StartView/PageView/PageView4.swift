//
//  PageView4.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct PageView4: View {
    var body: some View {
        ZStack {
            Color.hex("FEE086")
                        .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
             
                Text("Добавив геолокацию, вы можете закрыть ее от других пользователей или же сделать ее общедоступной. Вы можете написать владельцу данной точки, спросив его о чем угодно")
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

struct PageView4_Previews: PreviewProvider {
    static var previews: some View {
        PageView4()
    }
}
