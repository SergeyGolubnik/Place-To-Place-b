//
//  PhoneContactView.swift
//  Place-To-Place
//
//  Created by СОВА on 03.02.2022.
//

import SwiftUI



struct PhoneContactView: View {
    @StateObject var data = FirebaseData()
    @State var allUserTogle = false
    @Binding var arrayPhone: [String]
    @Binding var switchPlace: String
    @Binding var phoneContactApp: [PhoneContact]
    @Binding var phoneContactAppNoApp: [PhoneContact]
    var body: some View {
        VStack {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                .frame(width: 60, height: 12, alignment: .center)
                .padding(.vertical)
        
        List{
            
            Section(header: Text("Все"), footer: Text("Вы можете поделится точкой со всеми пользователями или оставть исключительно для собственного использования")) {
                VStack{
                    HStack{
                        Text(allUserTogle ? "Видите только вы" : "Видят все")
                        Toggle("", isOn: $allUserTogle).onTapGesture {
                            arrayPhone.removeAll()
                            if allUserTogle {
                                switchPlace = "Делится"
                            } else {
                                switchPlace = "Приватно"
                            }
                            
                        }
                    }
                }
                
            }
            if phoneContactAppNoApp != [] || phoneContactApp != [] {
                
                if allUserTogle {
                    Section(header: Text("Поделитесь с друзьями")) {
                        
                        ForEach(phoneContactApp, id: \.self) { contacts in
                            
                            if contacts.phoneNumber.count > 0 {
                                HStack{
                                    if phoneNumberContacns(pnoneContacts: contacts, phoneArray: arrayPhone) {
                                        ToggleContacts(name: contacts.name ?? "", image: contacts.image ?? Image(systemName: "person.crop.circle"), phone: contacts.phoneNumber, buttonBool: true, arrayPhone: $arrayPhone)
                                    } else {
                                        ToggleContacts(name: contacts.name ?? "", image: contacts.image ?? Image(systemName: "person.crop.circle"), phone: contacts.phoneNumber, arrayPhone: $arrayPhone)
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
                
                Section(header: Text("Пригласите в приложение")) {
                    
                    ForEach(phoneContactAppNoApp, id: \.self) { contacts in
                        
                        if contacts.phoneNumber.count > 0 {
                            HStack{
                                ToggleContactsNoApp(name: contacts.name ?? "", image: contacts.image ?? Image(systemName: "person.crop.circle"), phone: contacts.phoneNumber, arrayPhone: $arrayPhone)
                            }
                            
                        }
                    }
                }
            } else {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                              }
                } label: {
                    Text("Включите доступ к контактам")
                }

            }
        }
        .onAppear(perform: {
            if switchPlace != "Делится" {
                allUserTogle = true
            }
        })
        .onChange(of: arrayPhone) { newValue in
            if newValue != [] {
                switchPlace = "Приватно"
            } else {
                switchPlace = "Делится"
            }
        }
        
        
        }
        
    }
    private func phoneNumberContacns(pnoneContacts: PhoneContact, phoneArray: [String]) -> Bool {
        var summ = 0
        for phoneBoock in pnoneContacts.phoneNumber {
            if phoneArray.contains(phoneBoock) {
                summ += 1
            }
        }
        return summ != 0
    }
}

struct PhoneContactView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneContactView(arrayPhone: .constant([""]), switchPlace: .constant("Делится"), phoneContactApp: .constant([PhoneContact(name: "", avatarData: nil, phoneNumber: ["67757657676"])]),  phoneContactAppNoApp: .constant([PhoneContact(name: "", avatarData: nil, phoneNumber: ["67757657676"])]))
    }
}
