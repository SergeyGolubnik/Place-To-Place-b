//
//  NewPlaceView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.09.2021.
//

import SwiftUI
import MapKit



struct NewPlaceView: View {
    @State var categoryArray = Category()
    @StateObject var dataNewPlace = NewPlaceModel()
    
    
    @State var type = ""
    @State var typeString = ""
    @State var adressBool = false
    @State var groupBool = false
    @State var privateBool = true
    @State var messageBool = true
    @State var newPlaceGoo = false
    @State var imageGeleryPlaceArray = [UIImage]()
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
                HStack {
                    TextField("Введите название", text: $dataNewPlace.name)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    if dataNewPlace.name != "", dataNewPlace.location != "", dataNewPlace.type != "" {
                        Button {
                            newPlaceGoo.toggle()
                        } label: {
                            Text("Сохранить")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    } else {
                        Text("Сохранить")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    

                }
                
                
                    .padding(.horizontal)
                
                ScrollView {
                    VStack{
                        if dataNewPlace.location == "" {
                            Button {
                                adressBool = true
                            } label: {
                                ZStack{
                                    MapViewPresentBetta(latitude: dataNewPlace.latitude, longitude: dataNewPlace.longitude)
                                    Color.gray.opacity(0.3)
                                    Text("Укажите адрес или точку на карте")
                                        .foregroundColor(.black)
                                }
                                
                                .frame(height: 65)
                                .cornerRadius(10)
                                .padding(.vertical)
                                
                            }
                        }
                        
                        if dataNewPlace.location != "" {
                            VStack{
                                HStack{
                                    Text("Адрес:")
                                        .font(.body)
                                        .fontWeight(.light)
                                        .padding(.bottom)
                                    Spacer()
                                    if dataNewPlace.location != "" {
                                        Button {
                                            dataNewPlace.location = ""
                                        } label: {
                                            Text("Изменить")
                                        }.padding(.bottom)
                                    }
                                    
                                    
                                }
                                HStack(){
                                    Text(dataNewPlace.location)
                                    Spacer()
                                }
                            }
                            Capsule()
                                .frame(height: 1.5)
                                .foregroundColor(.gray)
                                .padding(.bottom, 15)
                        }
                        HStack{
                            
                            Button {
                                groupBool = true
                            } label: {
                                ZStack{
                                    if type != "" {
                                        Image(type)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .background(Color.gray.opacity(0.5))
                                            .cornerRadius(10)
                                    } else {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.gray)
                                        Text("Вибирете\nкатегорию")
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    }
                                    
                                }
                            }
                            Spacer()
                            Button {
                                privateBool.toggle()
                                if privateBool {
                                    dataNewPlace.switchPlace = "Делится"
                                } else {
                                    dataNewPlace.switchPlace = "Приватно"
                                }
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(privateBool ? .green : .blue)
                                    Text(privateBool ? "Видят\nвсе" : "Видите\nтолько вы")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            
                            
                            Spacer()
                            Button {
                                messageBool.toggle()
                                dataNewPlace.messageBool = messageBool
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(messageBool ? .green : .blue)
                                    Text(messageBool ? "Общатся" : "Не\nобщатся")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                            }
                            
                        }
                        VStack{
                            ImagePicker(imageArray: $imageGeleryPlaceArray)

                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $adressBool, content: {
            
            
            HomeMapPresent(annotationTitle: $dataNewPlace.location, coordinateLatitude: $dataNewPlace.latitude, coordinateLongitude: $dataNewPlace.longitude)
            
        })
        .sheet(isPresented: $groupBool) {
            CategoryView(enterType: $typeString)
        }
        .onChange(of: typeString, perform: { _ in
            if typeString != "" {
                dataNewPlace.type = typeString
                for i in categoryArray.categoryArray {
                    if i.name == typeString {
                        self.type = i.imageString!
                    }
                }
                print(typeString)
            }
        })
    }
    
}


struct NewPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPlaceView()
    }
}
