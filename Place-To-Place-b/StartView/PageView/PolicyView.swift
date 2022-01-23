//
//  PolicyView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 20.08.2021.
//

import SwiftUI


struct PolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isActive1 = false
    @State var isActive2 = false
    @State var isLoaderVisible = false
    
    
    var body: some View {
        
        ZStack {
            if isActive2 {
                FirstPage().transition(.scale(scale: 2))
            } else {
                VStack(spacing: 0) {
                    Text("Политика конфиденциальности")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    if isLoaderVisible {
                        LoaderView()
                    } else {
                        WebView(url: "https://place-to-place.ru/polici.html")
                    }
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            isActive1 = true
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text("Не согласен")
                        }
                        
                        Spacer()
                        Button(action: {
                            self.isActive2.toggle()
                        }){
                            Text("  Согласен  ")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }.padding()
                }
            }
            
            
            
            
        }
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
