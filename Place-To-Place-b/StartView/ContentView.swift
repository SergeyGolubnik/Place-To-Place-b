//
//  ContentView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack{
            Color.hex("FEE086")
                        .ignoresSafeArea()
            TabView {
                PageViev1()
                PageViev2()
                PageViev3()
                PageView4()
                PageView5()
            }.tabViewStyle(PageTabViewStyle())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
