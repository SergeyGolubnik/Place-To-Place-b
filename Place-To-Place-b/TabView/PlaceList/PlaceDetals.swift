//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @State var identifer: PlaceModel
    @State var updateView = false
    var body: some View {
        if identifer.key == "" {
            Button(action: {updateView.toggle()}, label: {
                
            })
        }
        Text(identifer.key)
    }
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetals(identifer: .init(key: "", userId: "", switchPlace: "", deviseToken: ""))
    }
}
