//
//  RegisterView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 30.08.2021.
//

import SwiftUI

struct RegisterView: View {
    @State var email = ""
    @State var name = ""
    @State var pass = ""
    @State var showSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var image: Image?
    
    var body: some View {
        ZStack{
            Color.hex("FEE086")
                .ignoresSafeArea()
            VStack{
                Text("Регистрация").fontWeight(.heavy).font(.largeTitle).foregroundColor(Color.black).padding()
                VStack{
                    VStack {
                        
                        Button(action: {
                            withAnimation {
                                self.showSheet.toggle()
                                
                            }
                        }) {
                            if image == nil {
                                Image("avatar-1").resizable().frame(width: 100, height: 100).cornerRadius(50)
                                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                            }
                            image?.resizable().frame(width: 100, height: 100).cornerRadius(50)
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
                                
                                TextField("Введите e-mail", text: $email)
                                
                                if email != ""{
                                    
                                    Image("check").foregroundColor(Color.init(.label))
                                }
                                
                            }
                            
                            Divider()
                            
                        }.padding(.bottom, 15)
                        VStack(alignment: .leading){
                            
                            Text("Имя").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                            HStack{
                                
                                TextField("Введите свое имя", text: $name)
                                
                                if name != ""{
                                    
                                    Image("check").foregroundColor(Color.init(.label))
                                }
                                
                            }
                            
                            Divider()
                            
                        }.padding(.bottom, 15)
                        
                        VStack(alignment: .leading){
                            
                            Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                            SecureField("Введите пароль", text: $pass)
                            
                            Divider()
                        }
                        VStack(alignment: .leading){
                            
                            Text("Пароль еще раз").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                            SecureField("Введите пароль еще раз", text: $pass)
                            
                            Divider()
                        }
                        
                    }.padding(.horizontal, 6)
                    
                }.padding()
                VStack{
                    
                    
                    
                    
                    Button(action: {
                        
                    }) {
                        
                        Text("Зарегестрироватся")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 120)
                            .padding()
                        
                        
                    }.background(Color.blue)
                    .clipShape(Capsule())
                    .padding([.top, .bottom], 60)
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
                    
                    
                }
            }
            
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
