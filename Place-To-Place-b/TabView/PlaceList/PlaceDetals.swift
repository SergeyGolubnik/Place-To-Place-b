//
//  PlaceDetals.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import SwiftUI

struct PlaceDetals: View {
    @State var identifer: PlaceModel
    var body: some View {
        Text(identifer.name!)
    }
}

struct PlaceDetals_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetals(identifer: .init(key: "", userId: "", switchPlace: "", deviseToken: ""))
    }
}
