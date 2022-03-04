//
//  FirstPage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 19.01.2022.
//

import SwiftUI
import Firebase

struct FirstPage : View {
    
    @State var ccode = "+1"
    @State var no = "1111111111"
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    
    
    var body : some View{
        
        VStack(spacing: 20){
            
            Image("pic")
            
            Text("Введите телефон для верификации").font(.largeTitle).fontWeight(.heavy)
            
            Text("Введите свой номер чтоб подвердить свой аккаунт")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            HStack{
                
                TextField("+1", text: $ccode)
                    .keyboardType(.numberPad)
                    .frame(width: 45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                
                TextField("Номер", text: $no)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } .padding(.top, 15)

            VStack {
                
                
                Button(action: {
                    
                    // remove this when testing with real Phone Number
                    
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.ccode + self.no, uiDelegate: nil) { (ID, err) in
                        
                        if err != nil{
                            
                            self.msg = (err?.localizedDescription)!
                            print(err?.localizedDescription ?? "Ошибка")
                            self.alert.toggle()
                            return
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                        
                    }
                    
                    
                }) {
                    
                    Text("Отправить").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    
                }.foregroundColor(.black)
                .background(colorApp)
                .cornerRadius(10)
                HStack {
                    Text("Может взыматся плата за СМС соглано вашему тарифу")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .padding()
                }
            }

            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        .fullScreenCover(isPresented: $show) {
            ScndPage(show: $show, ID: $ID)
        }
    }
}

struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
