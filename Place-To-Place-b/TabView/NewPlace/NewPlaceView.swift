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
    @StateObject var data = FirebaseData()
    
    @Published var namePlace = ""
    @Published var locationPlace = ""
    @Published var typeString = ""
    @Published var switchPlace = "Делится"
    @Published var messageBool = true
    @Published var discription = ""
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var type = ""
    
    
    @Published var isLoading = false
    @Published var messageAlert = ""
    @Published var titleAlert = ""
    @Published var adressBool = false
    @Published var groupBool = false
    @Published var privateBool = false
    
    
    @Published var arrayPhone = [String]()
    
    @Published var gelleryStringArray = [String]()
    
    
    var place: PlaceModel?
    var user: Users?
    init (place: PlaceModel?, user: Users?) {
        self.place = place
        self.user = user
        getPlaceData()
    }
    
    
    
    
    private func getPlaceData() {
        guard let place = place else { return }
        
        self.namePlace = place.name ?? ""
        self.locationPlace = place.location ?? ""
        self.typeString = place.type ?? ""
        self.switchPlace = place.switchPlace
        self.messageBool = place.messageBool ?? true
        self.discription = place.discription ?? ""
        self.latitude = place.latitude ?? ""
        self.longitude = place.longitude ?? ""
        gelleryStringArray.append((place.imageUrl) ?? "")
        if place.gellery != nil, place.gellery != [] {
            for imageGellery in (place.gellery)! {
                gelleryStringArray.append(imageGellery)
            }
        }
    }
    func newPlaceGet() {
        isLoading = true
        var geleryArray = [String]()
        if gelleryStringArray.count > 1 {
            for i in gelleryStringArray[1...] {
                geleryArray.append(i)
            }
        }
        FirebaseAuthDatabase.newPlace(name: namePlace, userId: user?.uid ?? "", phoneNumber: user?.phoneNumber ?? "", nikNamePlace: user?.lastName ?? "", avatarNikPlace: user?.avatarsURL ?? "", location: locationPlace, latitude: latitude, Longitude: longitude, type: typeString, image: gelleryStringArray[0], switchPlace: switchPlace, deviseToken: FirebaseData.shared.downUserData(), discription: discription, gellery: geleryArray, messageBool: messageBool, moderation: false, ref: data.ref) { result in
            
            switch result {
            case .success:
                self.isLoading = false
                self.titleAlert = "Поздравляем"
                self.messageAlert = "Ваша точка сохранилась"
            case .failure(let error):
                self.titleAlert = "Ошибка"
                self.messageAlert = error.localizedDescription
            }
        }
    }
    func rePlaceGet() {
        isLoading = true
        var geleryArray = [String]()
        if gelleryStringArray.count > 1 {
            for i in gelleryStringArray[1...] {
                geleryArray.append(i)
            }
        }
        FirebaseAuthDatabase.updatePlace(key: place!.key, name: namePlace, userId: user?.uid ?? "", nikNamePlace: user?.lastName ?? "", avatarNikPlace: user?.avatarsURL ?? "", phoneNumber: user?.phoneNumber ?? "", location: locationPlace, latitude: latitude, Longitude: longitude, type: typeString, image: gelleryStringArray[0], switchPlace: switchPlace, deviseToken: FirebaseData.shared.downUserData(), discription: discription, gellery: geleryArray, messageBool: messageBool, moderation: false, ref: data.ref) { result in
            switch result {
            case .success:
                self.isLoading = false
                self.titleAlert = "Поздравляем"
                self.messageAlert = "Ваша точка сохранилась"
            case .failure(let error):
                self.titleAlert = "Ошибка"
                self.messageAlert = error.localizedDescription
            }
        }
    }
}


struct NewPlaceView: View {
    
    @ObservedObject var mv: ModelNewPlaceView
    @StateObject var data = FirebaseData()
    @Environment(\.presentationMode) var presentationMode
    @State var newPlaceGoo = false
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
                                if mv.place == nil {
                                    mv.newPlaceGet()
                                    newPlaceGoo = true
                                } else {
                                    mv.rePlaceGet()
                                    newPlaceGoo = true
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
                                    if mv.isLoading {
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
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(mv.switchPlace == "Делится" ? .green : .blue)
                                    Text(mv.switchPlace == "Делится" ? "Видят\nвсе" : "Видите\nтолько вы")
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
            Alert(title: Text(mv.titleAlert), message: Text(mv.messageAlert), dismissButton: .default(Text("Ok"), action: {
                if mv.titleAlert == "Ошибка" {
                    mv.messageAlert = "Попробуйте позже"
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
        let place = ModelNewPlaceView(place: nil, user: nil)
        NewPlaceView(mv: place)
    }
}
