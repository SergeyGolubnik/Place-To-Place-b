//
//  RePasswordView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import SwiftUI

struct RePasswordView: View {
    @State private var textEmail: String = ""
    var body: some View {
        ZStack{
            Color.hex("FEE086")
                .ignoresSafeArea()
            VStack{
                VStack {
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.top)
                }

                VStack{
                    TextField("Введите свой e-mail", text: $textEmail)
                        .padding(.top,10)
                        .padding(.bottom,5)
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 70)
                        .padding(.horizontal)
                        
                }
                VStack{
                    Button(action: {
                        
                    }) {
                        
                     Text("Отправить")
                         .font(.title3)
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                         .frame(width: UIScreen.main.bounds.width - 120)
                         .padding()
                        
                        
                    }.background(Color.green)
                        .clipShape(Capsule())
                        .padding(.top, 45)
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
                }
                Spacer()
            }
            
        }
        
    }
}

struct RePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RePasswordView()
    }
}
