//
//  ToggleContacts.swift
//  Place-To-Place
//
//  Created by СОВА on 03.02.2022.
//

import SwiftUI

struct ToggleContacts: View {
    @State var name: String
    @State var image = Image(systemName: "person.crop.circle")
    @State var phone: [String]
    @State var sr = false
    @State var buttonBool = false
    @State private var arrayP = [String]()
    @Binding var arrayPhone: [String]
    
    var body: some View {
            HStack{
                VStack(spacing: 0){
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .clipped()
                }
                VStack{
                    
                    HStack(spacing: 0){
                        Text(name)
                            .multilineTextAlignment(.leading)
                            .font(.title3)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack{
                        Text(phone.count > 1 ? "\(phone.count) - телефона" : phone[0])
                            .lineLimit(1)
                        Spacer()
                    }
                }
                    //
                Spacer()
                Button {
                    buttonBool.toggle()
                    if buttonBool {
                        for phone in phone {
                            arrayPhone.append(phone)
                            arrayP.append(phone)
                        }
                    } else {
                        for phone in phone {
                            if let index = arrayPhone.firstIndex(of: phone) {
                                arrayPhone.remove(at: index)
                                arrayP.removeAll()
                            }
                        }
                    }
                    
                } label: {
                    Circle()
                        .foregroundColor(buttonBool ? .blue : .white)
                        .frame(width: 20, height: 20)
                        .padding(3)
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.label), lineWidth: 1))
                        
                        
                }
                

            }
            .onChange(of: arrayPhone) { newValue in
                if newValue == [] {
                    arrayP.removeAll()
                    buttonBool = false
                }
            }
        
    }
}

struct ToggleContacts_Previews: PreviewProvider {
    static var previews: some View {
        ToggleContacts(name: "Sergey", phone: ["7867852488768"], arrayPhone: .constant(["4678957"]))
        ToggleContactsNoApp(name: "Sergey", phone: ["7867852488768"], arrayPhone: .constant(["4678957"]))
    }
}


struct ToggleContactsNoApp: View {
    @State var name: String
    @State var image = Image(systemName: "person.crop.circle")
    @State var phone: [String]
    @State private var buttonBoolNoApp = false
    @Binding var arrayPhone: [String]

    var body: some View {
            HStack{
                VStack(spacing: 0){
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .clipped()
                }
                VStack{

                    HStack(spacing: 0){
                        Text(name)
                            .multilineTextAlignment(.leading)
                            .font(.title3)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack{
                        Text(phone.count > 1 ? "\(phone.count) - телефона" : phone[0])
                            .lineLimit(1)
                        Spacer()
                    }
                }
                    //
                Spacer()
                VStack{
                    Button {
                        buttonBoolNoApp.toggle()
                    } label: {

                        Text("Пригласить")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(width: UIScreen.main.bounds.width / 3)


                    } .background(Color.blue)
                        .clipShape(Capsule())
                }


            }


    }
}
