//
//  RePasswordView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import SwiftUI
import Firebase

struct RePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var textEmail: String = ""
    @State var alertText = ""
    @State var alertMessage = ""
    @State var alertBool = false
    @StateObject var data = FirebaseData()
    var body: some View {
        ZStack{
            Color.hex("FEE086")
                .ignoresSafeArea()
            VStack{
                VStack {
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.top)
                }
                
                VStack{
                    TextField("Введите свой e-mail", text: $textEmail)
                        .foregroundColor(.black)
                        .padding(.top,10)
                        .padding(.bottom,5)
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 70)
                        .padding(.horizontal)
                    
                }
                VStack{
                    Button(action: {
                        if !rePassvord() {
                            alertText = "Ошибка"
                            alertMessage = "Такого email не зарегестрированно"
                            alertBool = true
                        }
                        
                    }) {
                        
                        Text("Отправить")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 120)
                            .padding()
                        
                        
                    }.background(Color.green)
                        .clipShape(Capsule())
                        .padding(.top, 45)
                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                }
                Spacer()
            }
            
        }
        .alert(isPresented: $alertBool) {
            Alert(title: Text(alertText), message: Text(alertMessage), dismissButton: .default(Text("Ok"), action: {
                if alertText == "Ошибка" {
                    self.alertBool = false
                } else {
                    self.alertBool = true
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }))
            
        }
        .onAppear {
            self.data.getUserAll()
        }
        
    }
    func rePassvord() -> Bool {
        var resalt = false
        for i in self.data.userAll {
            if i.email.lowercased() == self.textEmail.lowercased() {
                resalt = true
                Auth.auth().sendPasswordReset(withEmail: self.textEmail) { (error) in
                    if error != nil {
                        alertText = "Ошибка"
                        alertMessage = error!.localizedDescription
                        alertBool = true
                    }
                    alertText = "Отправлено"
                    alertMessage = "На указанный Email отправлена ссылка для востоновления пароля"
                    alertBool = true
                }
                
            }
        }
        return resalt
    }
}

struct RePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RePasswordView()
    }
}
