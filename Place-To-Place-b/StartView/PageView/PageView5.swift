//
//  PageView5.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct PageView5: View {
    
    
    @State private var isActive = false
    
    
    
    var body: some View {
        
        ZStack {
            Color.hex("FEE086")
                .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
                
                Text("Это тестовая версия и если у вас есть предложения и замечания просьба писать их в журнале.")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(.horizontal)
                Spacer()
                Text("👇")
                    .font(.system(size: 100))
                    .padding(.bottom, -40)
                Spacer()
                Button("Поехали")
                {
                            self.isActive = true
                }
                .font(.title)
                .padding(.vertical, 14.0)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.bottom, 40).fullScreenCover(isPresented: $isActive, content: {
                    PolicyView()
                })
                
                
               
            }
            
        }
    }
}

struct PageView5_Previews: PreviewProvider {
    static var previews: some View {
        PageView5()
    }
}
