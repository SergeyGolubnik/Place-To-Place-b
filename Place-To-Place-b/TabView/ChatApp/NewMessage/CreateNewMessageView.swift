//
//  CreateNewMessageView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 14.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI



struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUsers) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = CreateNewMessageViewModel()
//    var user = ChatUsers(name: "Sergey", uid: "1235432", email: "Sergey@mail.ru", profileImage: "", token: "")
    var body: some View {
        NavigationView{
            ScrollView {
                ForEach(vm.users) {user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack{
                            WebImage(url: URL(string: user.profileImage))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.label), lineWidth: 1))
                            Text(user.name)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                }
            }
            .navigationBarColor(uiColorApp)
            .navigationTitle("Новое Сообщение").foregroundColor(.black)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Выйти")
                                .foregroundColor(.black)
                        }
                        
                    }
                }
        }
//        .onAppear {
//                presentationMode.wrappedValue.dismiss()
//                didSelectNewUser(user)
//
//        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        CreateNewMessageView(didSelectNewUser: {user in
//
//        })
                MainMessagesView()
    }
}
