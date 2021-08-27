//
//  PolicyView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 20.08.2021.
//

import SwiftUI


struct PolicyView: View {
    @State var isActive1 = false
    @State var isActive2 = false
    @ObservedObject var viewModel = ViewModel()
    @State var isLoaderVisible = false
    
    
    var body: some View {
        
        ZStack {
           
            
            VStack(spacing: 0) {
                Text("Политика конфиденциальности")
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                WebView(url: "https://place-to-place.ru/polici.html")
                HStack{
                    Spacer()
                    Button(action: {
                        isActive1 = true
                    }){
                        Text("Не согласен")
                    }.fullScreenCover(isPresented: $isActive1, content: {
                        ContentView()
                    })
                    
                    Spacer()
                    Button(action: {
                        isActive2 = true
                    }){
                        Text("  Согласен  ")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }.fullScreenCover(isPresented: $isActive2, content: {
                        LoginView()
                    })
                    
                    Spacer()
                }.padding()
            }
            if isLoaderVisible {
                LoaderView()
            }
            
        }
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
