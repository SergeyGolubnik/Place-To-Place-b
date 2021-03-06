//
//  PlaceList.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import SwiftUI
import MapKit

struct FavoritList: View {
    @State var placeArray = [PlaceModel]()
    @State var place: [PlaceModel]
    @Binding var deailPlace: PlaceModel
    @Binding var detailPlaceBool: Bool
    @EnvironmentObject var firebaseModel: FirebaseData
    var body: some View {
        
        NavigationView {
            
            if placeArray == [PlaceModel]() {
                Text("У вас не отмеченно любимых мест")
                    .navigationBarColor(uiColorApp)
                    .navigationBarTitle("Любимые места", displayMode: .inline)
            } else {
                List{
                    
                        ForEach(placeArray, id: \.id) { item in
                            
                            FavoritCell(imageURL: item.imageUrl!, name: item.name!, location: item.location!, placeRating: item.rating)
                                .onTapGesture {
                                    self.deailPlace = item
                                    self.detailPlaceBool = true
                                }
                        }
                        
                        .onDelete { indexSet in
                            deleteFavorit(indexSet: indexSet)
                        }
                }
                .listSeparatorStyle(style: .none)
                
                .listStyle(PlainListStyle())
                
                .navigationBarColor(uiColorApp)
                .navigationBarTitle("Любимые места", displayMode: .inline)
                
                
               
            }
             
        }
        .onAppear {
            
            for item in place {
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
    private func deleteFavorit(indexSet: IndexSet) {
        var favorit = [String]()
        var placeKey = ""
        for index in indexSet {
            
            placeKey = placeArray[index].key
            favorit = (placeArray[index].favorit?.filter {$0 != firebaseModel.user.uid})!
            placeArray.remove(at: index)
        }
        FirebaseAuthDatabase.updateFavorit(key: placeKey, favorit: favorit, ref: firebaseModel.ref) { resalt in
            switch resalt {
                
            case .success():
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}




struct ListSeparatorStyle: ViewModifier {
    
    let style: UITableViewCell.SeparatorStyle
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().separatorStyle = self.style
            }
    }
}
 
extension View {
    
    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style))
    }
}
