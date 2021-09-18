//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @Binding var identifer: PlaceModel
    @State var updateView = false
    var body: some View {
        
        Text(identifer.key)
            
    }
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetals(identifer: .constant(PlaceModel(key: "111", userId: "", switchPlace: "", deviseToken: "")))
    }
}
