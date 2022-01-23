//
//  RegisterView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 30.08.2021.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
   
    @State var name = ""
    @State var titleAlert = ""
    @State var isLoading = false
    @State var messageAlert = ""
    @State var alert = false
    @State var deviseToken = ""
    @Binding var goTabViewPlace: Bool
    @State var userArray = [Users]()
    @State var showSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @StateObject var data = FirebaseData()
    
    @State var image = UIImage(named: "avatar-1")
    
    var body: some View {
        
        ZStack{
            colorApp
                .ignoresSafeArea()
            
            ScrollView {
                VStack{
                    VStack {
                        Text("Регистрация")
                            .fontWeight(.heavy)
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                        
                            .padding()
                    }
                    VStack{
                        VStack {
                            
                            Button(action: {
                                withAnimation {
                                    self.showSheet.toggle()
                                    
                                }
                            }) {
                                Image(uiImage: image!)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
                                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                                
                            }.sheet(isPresented: $showImagePicker, content: {
                                OpenGallary(isShown: $showImagePicker, image: $image, imageBol: .constant(false), sourceType: sourceType)
                            })
                                .actionSheet(isPresented: $showSheet) {
                                    ActionSheet(title: Text("Загрузите фото"), message: nil, buttons: [
                                        .default(Text("Галерея")) {
                                            self.showImagePicker = true
                                            self.sourceType = .photoLibrary
                                        },
                                        .default(Text("Камера")) {
                                            self.showImagePicker = true
                                            self.sourceType = .camera
                                        },
                                        .cancel(Text("Выход"))
                                    ])
                                }
                            Text("Аватар")
                            
                        }.padding(.bottom, 30)
                        
                        VStack(alignment: .leading){
                            VStack(alignment: .leading){
                                
                                Text("Имя").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                
                                HStack{
                                    
                                    TextField("Введите свое имя", text: $name).foregroundColor(.black).multilineTextAlignment(.leading)
                                    
                                    
                                }
                                
                                Divider()
                                
                            }.padding(.bottom, 15)
                            
                        }.padding(.horizontal, 6)
                        HStack{
                            Text("Не допускается пробелы и \n(@,#,$,%,&,*,(,),^,<,>,!,±)").multilineTextAlignment(.center).font(.subheadline)
                        }
                    }.padding()
                    VStack{
                        Button(action: {
                            isLoading = true
                            for nik in data.userAll {
                                if nik.lastName == name {
                                    titleAlert = "Ошибка"
                                    messageAlert = "Такое имя уже существует"
                                    alert.toggle()
                                    isLoading = false
                                    return
                                }
                            }
                            if image == UIImage(named: "avatar-1"){
                                titleAlert = "Ошибка"
                                messageAlert = "Утановите аватар"
                                alert.toggle()
                                isLoading = false
                                return
                            }
                            if name == ""{
                                titleAlert = "Ошибка"
                                messageAlert = "Придумайте уникальный ник"
                                alert.toggle()
                                isLoading = false
                                return
                            }
                            if !isValidInput(Input: name) {
                                titleAlert = "Ошибка"
                                messageAlert = "Не допускается пробелы и \n(@,#,$,%,&,*,(,),^,<,>,!,±)"
                                alert.toggle()
                                name = ""
                                isLoading = false
                                return
                            }
                            if name != "", image != UIImage(named: "avatar-1") {
                                guard let currentUser = Auth.auth().currentUser else {return}
                                let user = Users(user: currentUser)
                                let nameString = name.trimmingCharacters(in: .whitespaces)
                                FirebaseAuthDatabase.registerPhone(photo: image, lastName: nameString, uid: user.uid, phoneNumber: user.phoneNumber ?? "1111111111", deviseToken: deviseToken) { resalt in
                                    switch resalt {
                                    case .success:
                                        isLoading = false
                                        alert.toggle()
                                        titleAlert = "Успешно"
                                        messageAlert = "Поздравляем!\nВы вошли под ником \(name)."
                                    case .failure(let error):
                                        isLoading = false
                                        alert.toggle()
                                        titleAlert = "Ошибка"
                                        messageAlert = "\(error.localizedDescription)"
                                    }
                                }
                            }
                        }) {
                            
                            Text("Зарегестрироватся")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .padding()
                            
                            
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
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding([.top, .bottom], 20)
                            .shadow(color: .gray, radius: 5, x: 5, y: 5)
                        
                        
                    }
                }
            }
            
        }
        .alert(isPresented: $alert) {
            Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("Ok"), action: {
                if messageAlert == "Такое имя уже существует" {
                    self.goTabViewPlace = false
                    name = ""
                }
                if titleAlert != "Ошибка" {
                    self.goTabViewPlace = true
                }
                
            }))
            
        }
        .onAppear {
            print(data.userAll)
            deviseToken = data.downUserData()
            print(data.downUserData())
        }
        
        
        
    }
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\w{4,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(goTabViewPlace: .constant(false))
    }
}
