//
//  PlaceList.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import SwiftUI

struct PlaceList: View {
    
    @EnvironmentObject var firebaseModel: FirebaseData
    
    var body: some View {
        
        NavigationView {
            
            ScrollView{
                VStack(spacing: 20){
                    ForEach(firebaseModel.places, id: \.id) { item in
                        Text(item.name ?? "ytn")
                    }
                }
            }
            .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
            .navigationBarTitle("Любимые места", displayMode: .inline)
            
            
            
        }
        
    }
    
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}


struct PlaceListView: View {
    
    
    var body: some View {
        
        VStack{
            
        }
        
    }
    
}
