//
//  ScndPage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 19.01.2022.
//



import SwiftUI
import Firebase

struct ScndPage : View {
    
    @State var code = "000000"
    @Binding var show : Bool
    @Binding var ID : String
    @State var msg = ""
    @State var alert = false
    @State var loading = false
    @State var goTabViewPlace = false
    @State var goRegisterUser = false
   
    
    var body : some View{
        if goTabViewPlace {
            TabViewPlace().transition(.scale)
        }else if goRegisterUser {
            RegisterView(goTabViewPlace: $goTabViewPlace)
        }else{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack(spacing: 20){
                        
                        Image("pic")
                        
                        Text("Код Верификации").font(.largeTitle).fontWeight(.heavy)
                        
                        Text("Пожалуйста, введите код с СМС")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        
                        TextField("Код", text: self.$code)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 15)
                        
                        
                        if self.loading{
                            
                            HStack{
                                
                                Spacer()
                                
                                Indicator()
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            
                            Button(action: {
                                
                                self.loading.toggle()
                                
                                let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                                
                                Auth.auth().signIn(with: credential) { (res, err) in
                                    
                                    if err != nil{
                                        
                                        self.msg = (err?.localizedDescription)!
                                        self.alert.toggle()
                                        self.loading.toggle()
                                        return
                                    }
                                    guard let currentUser = Auth.auth().currentUser else {return}
                                    let user = Users(user: currentUser)
                                    
                                    FirebaseData.shared.getUserData(user: user) { result in
                                        switch result {
                                        case .success(_):
                                            self.goTabViewPlace.toggle()
                                            self.loading.toggle()
                                        case .failure(_):
                                            self.goRegisterUser.toggle()
                                            self.loading.toggle()
                                        }
                                    }
                                    
                                }
                                
                            }) {
                                
                                Text("Подтвердить").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                                
                            }.foregroundColor(.black)
                                .background(colorApp)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image(systemName: "chevron.left").font(.title).foregroundColor(colorApp)
                    
                }.foregroundColor(.orange)
                
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
            }
        }
    }
}
struct ScndPage_Previews: PreviewProvider {
    static var previews: some View {
        ScndPage(show: .constant(false), ID: .constant(""))
    }
}
