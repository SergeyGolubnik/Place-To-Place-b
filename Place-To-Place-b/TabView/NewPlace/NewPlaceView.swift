//
//  NewPlaceView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 17.09.2021.
//

import SwiftUI
import MapKit
import Firebase


class ModelNewPlaceView: ObservableObject {
    @Published var categoryArray = Category()
    @Published var namePlace = ""
    @Published var locationPlace = ""
    @Published var typeString = ""
    @Published var switchPlace = "Делится"
    @Published var messageBool = true
    @Published var discription = ""
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var type = ""
    
    
    
    @Published var adressBool = false
    @Published var groupBool = false
    @Published var privateBool = false
    
    
    @Published var arrayPhone = [String]()
    
    @Published var gelleryStringArray = [String]()
    
    
    var place: PlaceModel?
    var user: Users?
    init (place: PlaceModel?) {
        self.place = place
        self.user = FirebaseData.shared.user
        getPlaceData()
    }
    
    
    
    
    private func getPlaceData() {
        guard let place = place else { return }
        
        self.namePlace = place.name ?? ""
        self.locationPlace = place.location ?? ""
        self.type = place.type ?? ""
        self.switchPlace = place.switchPlace
        self.messageBool = place.messageBool ?? true
        self.discription = place.discription ?? ""
        self.latitude = place.latitude ?? ""
        self.longitude = place.longitude ?? ""
        self.arrayPhone = place.phoneNumberArray ?? []
        gelleryStringArray.append((place.imageUrl) ?? "")
        if place.gellery != nil, place.gellery != [] {
            for imageGellery in (place.gellery)! {
                gelleryStringArray.append(imageGellery)
            }
        }
        if type != "" {
            for i in categoryArray.categoryArray {
                if i.name == type {
                    self.type = i.imageString!
                }
            }
        }
       
    }

    
}


struct NewPlaceView: View {
    
    @StateObject var mv: ModelNewPlaceView
    @StateObject var data = FirebaseData()
    @Environment(\.presentationMode) var presentationMode
    @State var newPlaceGoo = false
    @State var isLoading = false
    @State var messageAlert = ""
    @State var titleAlert = ""
    var body: some View {
        ScrollView{
            
            
            ZStack{
                VStack{
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.top)
                    Spacer()
                    if mv.namePlace == "" || mv.locationPlace == "" || mv.typeString == "" || mv.gelleryStringArray.count < 0 || mv.discription == "" {
                        Text("Заполните все поля")
                            .foregroundColor(.red)
                    }
                    
                    Text("Добавьте место на карте")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    HStack {
                        TextField("Введите название", text: $mv.namePlace)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        if mv.namePlace != "", mv.locationPlace != "", mv.typeString != "",  mv.gelleryStringArray.count > 0, mv.discription != "" {
                            Button {
                                isLoading = true
                                var geleryArray = [String]()
                                if mv.gelleryStringArray.count > 1 {
                                    for i in mv.gelleryStringArray[1...] {
                                        geleryArray.append(i)
                                    }
                                }
                                if mv.place == nil {
                                    FirebaseAuthDatabase.newPlace(name: mv.namePlace, userId: mv.user?.uid ?? "", phoneNumber: mv.user?.phoneNumber ?? "", phoneNumberArray: mv.arrayPhone, nikNamePlace: mv.user?.lastName ?? "", avatarNikPlace: mv.user?.avatarsURL ?? "", location: mv.locationPlace, latitude: mv.latitude, Longitude: mv.longitude, type: mv.typeString, image: mv.gelleryStringArray[0], switchPlace: mv.switchPlace, deviseToken: FirebaseData.shared.downUserData(), discription: mv.discription, gellery: geleryArray, messageBool: mv.messageBool, moderation: false, ref: data.ref) { result in
                                        
                                        switch result {
                                        case .success:
                                            self.titleAlert = "Поздравляем"
                                            self.messageAlert = "Ваша точка сохранилась"
                                            self.newPlaceGoo = true
                                            self.isLoading = false
                                        case .failure(let error):
                                            self.titleAlert = "Ошибка"
                                            self.messageAlert = error.localizedDescription
                                            self.newPlaceGoo = true
                                        }
                                    }
                                } else {
                                    FirebaseAuthDatabase.updatePlace(key: mv.place!.key, name: mv.namePlace, userId: mv.user?.uid ?? "", nikNamePlace: mv.user?.lastName ?? "", avatarNikPlace: mv.user?.avatarsURL ?? "", phoneNumber: mv.user?.phoneNumber ?? "", phoneNumberArray: mv.arrayPhone, location: mv.locationPlace, latitude: mv.latitude, Longitude: mv.longitude, type: mv.typeString, image: mv.gelleryStringArray[0], switchPlace: mv.switchPlace, deviseToken: FirebaseData.shared.downUserData(), discription: mv.discription, gellery: geleryArray, messageBool: mv.messageBool, moderation: false, ref: data.ref) { result in
                                        switch result {
                                        case .success:
                                            self.titleAlert = "Поздравляем"
                                            self.messageAlert = "Ваша точка сохранилась"
                                            self.isLoading = false
                                            self.newPlaceGoo = true
                                        case .failure(let error):
                                            self.titleAlert = "Ошибка"
                                            self.messageAlert = error.localizedDescription
                                            self.newPlaceGoo = true
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
                    VStack{
                        if mv.locationPlace == "" {
                            Button {
                                mv.adressBool = true
                            } label: {
                                ZStack{
                                    MapViewPresentBetta(latitude: mv.latitude, longitude: mv.longitude)
                                    Color.gray.opacity(0.3)
                                    Text("Укажите адрес или точку на карте")
                                        .foregroundColor(.black)
                                }
                                
                                .frame(height: 65)
                                .cornerRadius(10)
                                .padding(.vertical)
                                
                            }
                        }
                        
                        if mv.locationPlace != "" {
                            VStack{
                                HStack{
                                    Text("Адрес:")
                                        .font(.body)
                                        .fontWeight(.light)
                                        .padding(.bottom)
                                    Spacer()
                                    if mv.locationPlace != "" {
                                        Button {
                                            mv.locationPlace = ""
                                        } label: {
                                            Text("Изменить")
                                        }.padding(.bottom)
                                    }
                                    
                                    
                                }
                                HStack(){
                                    Text(mv.locationPlace)
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
                                mv.groupBool = true
                            } label: {
                                ZStack{
                                    if mv.type != "" {
                                        Image(mv.type)
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
                                mv.privateBool.toggle()
//                                data.getContact()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(mv.switchPlace == "Делится" ? .green : .blue)
                                    Text(mv.switchPlace == "Делится" ? "Видят\nвсе" : mv.arrayPhone != [] ? "Видите\nтолько вы\nи друзья" : "Видите\nтолько вы")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            
                            
                            Spacer()
                            Button {
                                mv.messageBool.toggle()
                                
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(mv.messageBool ? .green : .blue)
                                    Text(mv.messageBool ? "Общатся" : "Не\nобщатся")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }
                            }
                            
                        }
                        VStack{
                            ImagePicker(gelleryStringArray: $mv.gelleryStringArray)
                                .padding(.bottom)
                            Text("Напишите пару слов о вашем месте:")
                            TextEditor(text: $mv.discription)
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
                    
                    
                    
                    Spacer()
                }.ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $mv.adressBool, content: {
            
            
            HomeMapPresent(annotationTitle: $mv.locationPlace, coordinateLatitude: $mv.latitude, coordinateLongitude: $mv.longitude)
            
        })
        
        .sheet(isPresented: $mv.groupBool) {
            CategoryView(enterType: $mv.typeString, imageString: $mv.type)
        }
        .sheet(isPresented: $mv.privateBool) {
            PhoneContactView(arrayPhone: $mv.arrayPhone, switchPlace: $mv.switchPlace, phoneContactApp: $data.contactArrayAppPlace, phoneContactAppNoApp: $data.contactArrayAppPlaceNoApp)
        }
        
        .alert(isPresented: $newPlaceGoo) {
            
            Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("Ok"), action: {
                if titleAlert == "Ошибка" {
                    messageAlert = "Попробуйте позже"
                } else {
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
                
            }))
            
        }
    }
    
}


struct NewPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        let place = ModelNewPlaceView(place: nil)
        NewPlaceView(mv: place)
    }
}
