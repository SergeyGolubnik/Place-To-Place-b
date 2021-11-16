//
//  NewPlaceView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.09.2021.
//

import SwiftUI
import MapKit



struct NewPlaceView: View {
    @State var adressBool = false
    var body: some View {
        ZStack{
            VStack{
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 12, alignment: .center)
                    .padding(.top)
                Spacer()
                Text("Добавте место на карте")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                
            
                HStack{
                    GeometryReader { geometry in
                        Button {
                            adressBool = true
                        } label: {
                            ZStack{
                                MapViewPresent()
                                
                                Text("Укажите адрес или точку на карте")
                                    .foregroundColor(.black)
                                    
                            }
                            .frame(width: geometry.size.width - 30, height: geometry.size.height / 7)
                            .cornerRadius(10)
                            .padding()
                            
                        }

                        
                        Spacer()
                    }
                    
                }
                Spacer()
            }
        }
        
    }
    
}


struct NewPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlaceView()
    }
}
