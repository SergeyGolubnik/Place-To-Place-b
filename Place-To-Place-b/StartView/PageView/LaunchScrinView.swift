//
//  LaunchScrinView.swift
//  Place-To-Place
//
//  Created by СОВА on 20.01.2022.
//

import SwiftUI

struct LaunchScrinView: View {
    var body: some View {
        ZStack {
            Color.hex("FEE086")
                        .ignoresSafeArea()
            VStack{
                
                Text("Place To Place").font(.custom("Marker Felt Thin", fixedSize: 40)).padding(.vertical, 20)
             
                
                
            }
            
            
            
        }
    }
}

struct LaunchScrinView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScrinView()
    }
}
