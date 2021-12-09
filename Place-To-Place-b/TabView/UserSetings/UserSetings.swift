//
//  UserSetings.swift
//  Place-To-Place-b
//
//  Created by СОВА on 05.10.2021.
//

import SwiftUI
import Firebase

struct UserSetings: View {
    @Binding var exitBool: Bool
    var body: some View {
        
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
}

struct UserSetings_Previews: PreviewProvider {
    static var previews: some View {
        UserSetings(exitBool: .constant(false))
    }
}
