//
//  PlaceList.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import SwiftUI

struct FavoritList: View {
    @State var placeArray = [PlaceModel]()
    @Binding var deailPlace: PlaceModel
    @Binding var detailPlaceBool: Bool
    @EnvironmentObject var firebaseModel: FirebaseData
    
    var body: some View {
        
        NavigationView {
            
            ScrollView{
                VStack(spacing: 20){
                    ForEach(placeArray, id: \.id) { item in
                        FavoritCell(imageURL: item.imageUrl!, name: item.name!, location: item.location!, placeRating: item.rating)
                            .onTapGesture {
                                self.deailPlace = item
                                self.detailPlaceBool = true
                            }
                    }
                }.padding(.top)
            }
            .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
            .navigationBarTitle("Любимые места", displayMode: .inline)
            
            
            
        }
        .onAppear {
            
            for item in firebaseModel.places {
                if item.favorit != nil {
                    for i in item.favorit! {
                        if i == self.firebaseModel.users.uid {
                            placeArray.append(item)
                        }
                    }
                }
            }
        }
        .environmentObject(firebaseModel)
        
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
