//
//  UserSetings.swift
//  Place-To-Place-b
//
//  Created by СОВА on 05.10.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct UserSetings: View {
    @State var avatarUpdate = false
    @State var placeMy = false
    @State var place = [PlaceModel]()
    @Binding var user: Users
    @Binding var exitBool: Bool
    var body: some View {
        NavigationView {
            
            VStack{
                VStack{
                    WebImage(url: URL(string: user.avatarsURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(150)
                        .clipped()
                        .shadow(radius: 5)
                    Button {
                        avatarUpdate = true
                    } label: {
                        Text("Изменить")
                    }

                }.padding()
                VStack{
                    List{
                        NavigationLink("Ваши места", isActive: $placeMy) {
                            FavoritList(title: "Все", place: place)
                            
                        }

                    }
                }
                Spacer()
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            exitBool = true
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }) {
                        Text("Выход")
                            .frame(width: 70, height: 30, alignment: .center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                
            }
            
            .background(Color(.init(gray: 0.7, alpha: 0.19)))
            .navigationBarColor(uiColorApp)
            
            .navigationBarTitle(user.lastName ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
        }
        
    }
}

struct UserSetings_Previews: PreviewProvider {
    static var previews: some View {
        UserSetings(user: .constant(Users(lastName: "Sergey", email: "sergey8282@list.ru", avatarsURL: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/avatars%2FxWqXJkftXjZKlf1JCBHY1dkvdPN2?alt=media&token=45dc9b14-f65d-44e5-9d90-6867faa419ae", uid: "12343234", deviseToken: "ewtv4t", phoneNumber: "+79773448064")), exitBool: .constant(false))
    }
}

