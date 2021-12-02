//
//  NewPlaceView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.09.2021.
//

import SwiftUI
import MapKit



struct NewPlaceView: View {
    @State var placeName = ""
    @State var annotationTitle = ""
    @State var coordinateLatitude: String
    @State var coordinateLongitude: String
    @State var adressBool = false
    @State var data = MapViewModel()
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
                TextField("Введите название", text: $placeName)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    .padding(.horizontal)
                    
            
                HStack{
                    GeometryReader { geometry in
                        VStack{
                            Button {
                                adressBool = true
                            } label: {
                                ZStack{
                                    MapViewPresentBetta()
                                        .frame(width: geometry.size.width - 30, height: geometry.size.height / 9)
                                    
                                    Text("Укажите адрес или точку на карте")
                                        .frame(width: geometry.size.width - 30, height: geometry.size.height / 9)
                                        .foregroundColor(.black)
                                        .background(Color.gray.opacity(0.3))
                                        
                                }
                                .cornerRadius(10)
                                .padding()
                                
                            }
                            if annotationTitle != "" {
                                VStack{
                                    HStack{
                                        Text("Адрес:")
                                            .font(.body)
                                            .fontWeight(.light)
                                            .padding(.bottom)
                                        Spacer()
                                    }
                                    HStack(){
                                        Text(annotationTitle)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                                Capsule()
                                    .padding(.horizontal)
                                    .frame(height: 1.5)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        
                    }
                    
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $adressBool, content: {
          
                
            HomeMapPresent(annotationTitle: $annotationTitle, coordinateLatitude: $coordinateLatitude, coordinateLongitude: $coordinateLongitude)
            
        })
    }
    
}


struct NewPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPlaceView(annotationTitle: "", coordinateLatitude: "", coordinateLongitude: "")
    }
}
