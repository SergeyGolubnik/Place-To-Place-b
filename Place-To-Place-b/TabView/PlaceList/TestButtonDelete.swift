//
//  TestButtonDelete.swift
//  Place-To-Place
//
//  Created by СОВА on 04.03.2022.
//

import SwiftUI
import Firebase

struct TestButtonDelete: View {
    
    let db = Firestore.firestore()
    
    var body: some View {
        Button {
            db.collection("messages").document("v6uZ4LP9xyOaC9H0uPpdX5gj5xF2").collection("swjITaC8zPZ5rjdML7LZftuaZCi1").document("7utodeV9NwyRQZqt0Dmn").delete(){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        } label: {
            Text("Button")
        }
        
    }
}

struct TestButtonDelete_Previews: PreviewProvider {
    static var previews: some View {
        TestButtonDelete()
    }
}
