//
//  LoginView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct LoginView: View {
    @State private var goToViewRegister = false
    @State private var goToViewRePassword = false
    @State private var goToViewTabViev = false
    @State private var alert = false
    @State var goTabViewPlace = false
    @State private var message = ""
    @State var email = ""
    @State var pass = ""
    
    var body: some View {
        if goToViewTabViev || goTabViewPlace {
            TabViewPlace().transition(.scale)
        }else{
            ZStack{
                Color.hex("FEE086")
                    .ignoresSafeArea()
                VStack{
                    Text("Вход").fontWeight(.heavy).font(.largeTitle).padding(.bottom, 60)
                    VStack{
                        
                        VStack(alignment: .leading){
                            
                            VStack(alignment: .leading){
                                
                                Text("E-mail").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                
                                TextField("Введите e-mail", text: $email)
                                
                                Divider()
                                
                            }.padding(.bottom, 15)
                            
                            VStack(alignment: .leading){
                                
                                Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                                
                                SecureField("Введите пароль", text: $pass)
                                
                                Divider()
                            }
                            
                        }.padding(.horizontal, 6)
                        
                    }.padding()
                    VStack{
                        
                        Button(action: {
                            
                            FirebaseAuthDatabase.loginPressed(email: self.email, password: self.pass) { (rezalt, status) in
                                switch rezalt{
                                
                                case true:
                                    self.goToViewTabViev = true
                                    
                                case false:
                                    self.message = status
                                    self.alert = true
                                    
                                }
                            }
                        }) {
                            
                            Text("Войти")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 120)
                                .padding()
                            
                            
                        }.background(Color.green)
                        .clipShape(Capsule())
                        .padding(.top, 45)
                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                        
                        
                        Text("(или)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,8)
                        
                        Button(action: {
                            self.goToViewRegister.toggle()
                        }) {
                            
                            Text("Зарегестрироватся")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 120)
                                
                                .padding()
                                
                                .sheet(isPresented: $goToViewRegister, content: {
                                    RegisterView(goTabViewPlace: $goTabViewPlace)
                                })
                            
                            
                        }.background(Color.blue)
                        .clipShape(Capsule())
                        .padding(.top,8)
                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                        
                        HStack(spacing: 8){
                            
                            Text("Забыл пароль?").foregroundColor(Color.gray.opacity(0.5))
                            
                            Button(action: {
                                self.goToViewRePassword.toggle()
                            }) {
                                
                                Text("Жми")
                                    .sheet(isPresented: $goToViewRePassword, content: {
                                        RePasswordView()
                                    })
                            }.foregroundColor(.blue)
                            
                        }.padding(.top, 50)
                        
                    }
                }
                
            }
            .alert(isPresented: $alert) {
                Alert(title: Text("Ошибка"), message: Text(message), dismissButton: .default(Text("Ок")))
            }
            
            
            
            
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
