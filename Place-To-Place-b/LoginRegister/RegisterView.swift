//
//  RegisterView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 30.08.2021.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var email = ""
    @State var name = ""
    @State var pass = ""
    @State var pass2 = ""
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var alert = false
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
                        VStack{
                            Capsule()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                                .frame(width: 60, height: 12, alignment: .center)
                                .padding(.top)
                            Spacer()
                        }
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
                                    OpenGallary(isShown: $showImagePicker, image: $image, sourceType: sourceType)
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
                                    
                                    Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                    
                                    HStack{
                                        
                                        TextField("Введите e-mail", text: $email).foregroundColor(.black).multilineTextAlignment(.leading)
                                    
                                        
                                    }
                                    
                                    Divider()
                                    
                                }.padding(.bottom, 15)
                                VStack(alignment: .leading){
                                    
                                    Text("Имя").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                    
                                    HStack{
                                        
                                        TextField("Введите свое имя", text: $name).foregroundColor(.black).multilineTextAlignment(.leading)

                                        
                                    }
                                    
                                    Divider()
                                    
                                }.padding(.bottom, 15)
                                
                                VStack(alignment: .leading){
                                    
                                    Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                    
                                    SecureField("Введите пароль", text: $pass).foregroundColor(.black).multilineTextAlignment(.leading)
                                    
                                    Divider()
                                }
                                VStack(alignment: .leading){
                                    
                                    Text("Пароль еще раз").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                    
                                    SecureField("Введите пароль еще раз", text: $pass2).foregroundColor(.black).multilineTextAlignment(.leading)
                                    
                                    Divider()
                                }
                                
                            }.padding(.horizontal, 6)
                            
                        }.padding()
                        VStack{
                            Button(action: {
                                if email != "", Validators.isSimpleEmail(email) {
                                    if pass != "", pass2 != "", pass == pass2 {
                                        for i in data.userAll {
                                            if name == i.lastName {
                                                titleAlert = "Ошибка"
                                                messageAlert = "Такое имя уже существует"
                                                alert.toggle()
                                                return
                                            }
                                        }
                                        if name != "" {
                                            FirebaseAuthDatabase.register(photo: image, lastName: name, email: email, password: pass, deviseToken: "временно пока не подключу нотисфакшен") { resalt in
                                                switch resalt {
                                                case .success:
                                                    alert.toggle()
                                                    titleAlert = "Успешно"
                                                    messageAlert = "Поздравляем!\nВы зарегестрировал."
                                                case .failure(let error):
                                                    alert.toggle()
                                                    titleAlert = "Ошибка"
                                                    messageAlert = "\(error.localizedDescription)"
                                                }
                                            }
                                        } else {
                                            titleAlert = "Ошибка"
                                            messageAlert = "Некоректно веден пароль"
                                            alert.toggle()
                                            return
                                        }
                                    } else {
                                        titleAlert = "Ошибка"
                                        messageAlert = "Некоректно ведено имя"
                                        alert.toggle()
                                        return
                                    }
                                } else {
                                    titleAlert = "Ошибка"
                                    messageAlert = "Некоректно веден Email"
                                    alert.toggle()
                                    return
                                }
                            }) {
                                
                                Text("Зарегестрироватся")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 120)
                                    .padding()
                                
                                
                            }.background(Color.blue)
                                .clipShape(Capsule())
                                .padding([.top, .bottom], 20)
                                .shadow(color: .gray, radius: 5, x: 5, y: 5)
                            
                            
                        }
                    }
                }
                
            }
            .alert(isPresented: $alert) {
                Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("Ok"), action: {
                    if titleAlert == "Ошибка" {
                        self.goTabViewPlace = false
                    } else if messageAlert == "Такое имя уже существует" {
                        self.goTabViewPlace = false
                        name = ""
                    } else {
                        self.goTabViewPlace = true
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }))
                
            }
            .onAppear {
                data.getUserAll()
                print(data.userAll)
                
            }
        
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(goTabViewPlace: .constant(false))
    }
}
