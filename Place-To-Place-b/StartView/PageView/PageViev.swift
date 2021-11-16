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
            colorApp
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
struct PageViev2: View {
    
    
    var body: some View {
        ZStack {
            colorApp
                        .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
             
                Text("После того как вы зарегистрируетесь всего лишь указав почту")
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

struct PageViev2_Previews: PreviewProvider {
    static var previews: some View {
        PageViev2()
    }
}
struct PageViev3: View {
    
    var body: some View {
        ZStack {
            colorApp
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

struct PageView4: View {
    var body: some View {
        ZStack {
            colorApp
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
struct PageView5: View {
    
    
    @State private var isActive = false
    
    
    
    var body: some View {
        
        ZStack {
            colorApp
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
                .padding(.bottom, 40)
                .fullScreenCover(isPresented: $isActive, content: {
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
