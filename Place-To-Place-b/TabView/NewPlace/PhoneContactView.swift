//
//  PhoneContactView.swift
//  Place-To-Place
//
//  Created by СОВА on 03.02.2022.
//

import SwiftUI



struct PhoneContactView: View {
    @ObservedObject var data = FirebaseData()
    @State var allUserTogle = false
    @Binding var arrayPhone: [String]
    @Binding var switchPlace: String
    @Binding var phoneContactApp: [PhoneContact]
    @Binding var phoneContactAppNoApp: [PhoneContact]
    var body: some View {
        
        List{
            ForEach(arrayPhone, id: \.self) { i in
                Text(i)
            }
            Section(header: Text("hwrvwru")) {
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
                        Text(switchPlace)
                    }
                }
            }
            if !allUserTogle {
                Section(header: Text("hwrvwru")) {
                    
                    ForEach(phoneContactApp, id: \.id) { contacts in
                        
                        if contacts.phoneNumber.count > 0 {
                            HStack{
                                if phoneNumberContacns(pnoneContacts: contacts, phoneArray: arrayPhone) {
                                    ToggleContacts(name: contacts.name!, phone: contacts.phoneNumber, buttonBool: true, arrayPhone: $arrayPhone)
                                } else {
                                    ToggleContacts(name: contacts.name!, phone: contacts.phoneNumber, arrayPhone: $arrayPhone)
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
            Section(header: Text("hwrvwru")) {
                
                ForEach(phoneContactAppNoApp, id: \.id) { contacts in
                    
                    if contacts.phoneNumber.count > 0 {
                        HStack{
                            ToggleContactsNoApp(name: contacts.name!, phone: contacts.phoneNumber, arrayPhone: $arrayPhone)
                        }
                    }
                }
            }
        }
        .onChange(of: arrayPhone) { newValue in
            if newValue != [] {
                switchPlace = "Приватно"
            } else {
                switchPlace = "Делится"
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
