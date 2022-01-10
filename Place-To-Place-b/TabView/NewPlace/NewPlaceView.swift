//
//  NewPlaceView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.09.2021.
//

import SwiftUI
import MapKit
import Firebase



struct NewPlaceView: View {
    @State var categoryArray = Category()
    @State var place: PlaceModel?
    @StateObject var data = FirebaseData()
    @Environment(\.presentationMode) var presentationMode
    
    @State var namePlace = ""
    @State var locationPlace = ""
    @State var typeString = ""
    @State var switchPlace = ""
    @State var messageBool = true
    @State var imageGeleryPlaceArray = [UIImage]()
    @State var discription = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var gelleryStringArray = [String]()
    
    @State var type = ""
    
    @State var isLoading = false
    @State var messageAlert = ""
    @State var titleAlert = ""
    @State var adressBool = false
    @State var groupBool = false
    @State var privateBool = true
    
    @State var newPlaceGoo = false
    
    var body: some View {
        ZStack{
            VStack{
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 12, alignment: .center)
                    .padding(.top)
                Spacer()
                if namePlace == "" || locationPlace == "" || typeString == "" || imageGeleryPlaceArray.count < 0 || discription == "" {
                    Text("Заполните все поля")
                        .foregroundColor(.red)
                }
                
                Text("Добавьте место на карте")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                HStack {
                    TextField("Введите название", text: $namePlace)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    if namePlace != "", locationPlace != "", typeString != "",  imageGeleryPlaceArray.count > 0, discription != "" {
                        Button {
                            isLoading = true
                            var geleryArray = [String]()
                            if gelleryStringArray.count > 1 {
                                for i in gelleryStringArray[1...] {
                                    geleryArray.append(i)
                                }
                            }
                        
                            if place == nil {
                                FirebaseAuthDatabase.newPlace(name: namePlace, userId: data.user.uid, location: locationPlace, latitude: latitude, Longitude: longitude, type: typeString, image: gelleryStringArray[0], switchPlace: switchPlace, deviseToken: data.downUserData(), discription: discription, gellery: geleryArray, messageBool: messageBool, ref: data.ref) { result in
                                    
                                    switch result {
                                    case .success:
                                            isLoading = false
                                            newPlaceGoo.toggle()
                                            titleAlert = "Поздравляем"
                                            messageAlert = "Ваша точка сохранилась"
                                    case .failure(let error):
                                        newPlaceGoo.toggle()
                                        titleAlert = "Ошибка"
                                        messageAlert = error.localizedDescription
                                    }
                                }
                            } else {
                                FirebaseAuthDatabase.updatePlace(key: place!.key, name: namePlace, userId: data.user.uid, location: locationPlace, latitude: latitude, Longitude: longitude, type: typeString, image: gelleryStringArray[0], switchPlace: switchPlace, deviseToken: data.downUserData(), discription: discription, gellery: geleryArray, ref: data.ref) { result in
                                    switch result {
                                    case .success:
                                        isLoading = false
                                        newPlaceGoo.toggle()
                                        titleAlert = "Поздравляем"
                                        messageAlert = "Ваша точка сохранилась"
                                    case .failure(let error):
                                        newPlaceGoo.toggle()
                                        titleAlert = "Ошибка"
                                        messageAlert = error.localizedDescription
                                    }
                                }
                            }
                            
                        } label: {
                            Text("Сохранить")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }.overlay (
                            ZStack {
                                if isLoading {
                                    Color.black
                                        .opacity(0.25)
                                    
                                    ProgressView()
                                        .font(.title2)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(12)
                                }
                            })
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
                        if locationPlace == "" {
                            Button {
                                adressBool = true
                            } label: {
                                ZStack{
                                    MapViewPresentBetta(latitude: latitude, longitude: longitude)
                                    Color.gray.opacity(0.3)
                                    Text("Укажите адрес или точку на карте")
                                        .foregroundColor(.black)
                                }
                                
                                .frame(height: 65)
                                .cornerRadius(10)
                                .padding(.vertical)
                                
                            }
                        }
                        
                        if locationPlace != "" {
                            VStack{
                                HStack{
                                    Text("Адрес:")
                                        .font(.body)
                                        .fontWeight(.light)
                                        .padding(.bottom)
                                    Spacer()
                                    if locationPlace != "" {
                                        Button {
                                            locationPlace = ""
                                        } label: {
                                            Text("Изменить")
                                        }.padding(.bottom)
                                    }
                                    
                                    
                                }
                                HStack(){
                                    Text(locationPlace)
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
                                    switchPlace = "Делится"
                                } else {
                                    switchPlace = "Приватно"
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
                            ImagePicker(imageArray: $imageGeleryPlaceArray, gelleryStringArray: $gelleryStringArray)
                                .padding(.bottom)
                            Text("Напишите пару слов о вашем месте:")
                            TextEditor(text: $discription)
                                .cornerRadius(5)
                                .padding()
                                .frame(height: 200)
                                .shadow(radius: 3)
                        }
                        VStack{
                            
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                }
                
                Spacer()
            }.ignoresSafeArea()
        }
        .onAppear(perform: {
            if place != nil {
                namePlace = place?.name ?? ""
                locationPlace = place?.location ?? ""
                typeString = place?.type ?? ""
                switchPlace = place?.switchPlace ?? ""
                messageBool = place?.messageBool ?? true
                discription = place?.discription ?? ""
                latitude = place?.latitude ?? ""
                longitude = place?.longitude ?? ""
                imageGeleryPlaceArray.append(data.getImageUIImage(url: (place?.imageUrl)!))
                gelleryStringArray.append((place?.imageUrl)!)
                if place?.gellery != nil, place?.gellery != [] {
                    for imageGellery in (place?.gellery)! {
                        gelleryStringArray.append(imageGellery)
                        imageGeleryPlaceArray.append(data.getImageUIImage(url: imageGellery))
                    }
                }
                
                
            }
        })
        .fullScreenCover(isPresented: $adressBool, content: {
            
            
            HomeMapPresent(annotationTitle: $locationPlace, coordinateLatitude: $latitude, coordinateLongitude: $longitude)
            
        })
        
        .sheet(isPresented: $groupBool) {
            CategoryView(enterType: $typeString)
        }
        .onChange(of: typeString, perform: { _ in
            if typeString != "" {
                for i in categoryArray.categoryArray {
                    if i.name == typeString {
                        self.type = i.imageString!
                    }
                }
                print(typeString)
            }
        })
        .alert(isPresented: $newPlaceGoo) {
            Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("Ok"), action: {
                if titleAlert == "Ошибка" {
                    messageAlert = "Попробуйте позже"
                } else {
                    self.data.places.removeAll()
                    self.data.fetchData()
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
                
            }))
            
        }
    }
    
}


struct NewPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPlaceView()
    }
}
