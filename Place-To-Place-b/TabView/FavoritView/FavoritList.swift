//
//  PlaceList.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import SwiftUI
import MapKit

struct FavoritList: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var placeDetailViewModel: PlaceDetalsViewModel
    @State var title: String
    @State var placeArray = [PlaceModel]()
    @State var place: [PlaceModel]
    @State var textMessage = ""
    @State var detailPlaceBool = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                
                Text(textMessage)
                if placeArray == [PlaceModel]() {
                    Text("У вас не отмеченно любимых мест")
                } else {
                    List{
                        
                        ForEach(placeArray, id: \.id) { item in
                            Button  {
                                self.placeDetailViewModel.places = item
                                
                                if title != "Все", title != "Любимые места" {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.detailPlaceBool = true
                                }
                                print("FavoritList ---- detailPlaceBool --- \(self.detailPlaceBool)")
                            } label: {
                                FavoritCell(imageURL: item.imageUrl ?? "", name: item.name ?? "", location: item.location ?? "", placeRating: item.rating)
                            }.foregroundColor(.black)
                                
                        }
                        .onDelete { indexSet in
                            if title == "Все" {
                                deletePlace(indexSet: indexSet)
                            } else if title == "Любимые места" {
                                deleteFavorit(indexSet: indexSet)
                            }
                        }
                        
                    }.listStyle(.plain)
                    .toolbar  {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            if title != "Любимые места" {
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Text("Выйти")
                                        .foregroundColor(.blue)
                                }
                            }

                        }
                    }
                }
                
            }
            .navigationBarColor(uiColorApp)
            .navigationBarTitle(title, displayMode: .inline)
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if title == "Все" {
                placeArray = place.filter { $0.userId == FirebaseData.shared.user.uid}
            } else if title == "Любимые места" {
                
                for item in place {
                    if item.favorit != nil {
                        
                        for i in item.favorit! {
                            if i == FirebaseData.shared.user.uid {
                                placeArray.append(item)
                            }
                        }
                    }
                }
            } else {
                placeArray = place.filter { $0.userId == placeDetailViewModel.places?.userId}
            }
        }
        .sheet(isPresented: $detailPlaceBool, content: {
            PlaceDetals(vm: placeDetailViewModel)
        })
    }
    private func deleteFavorit(indexSet: IndexSet) {
        var favorit = [String]()
        var placeKey = ""
        for index in indexSet {
            placeKey = placeArray[index].key
            favorit = (placeArray[index].favorit?.filter {$0 != FirebaseData.shared.user.uid})!
            placeArray.remove(at: index)
        }
        FirebaseAuthDatabase.updateFavorit(key: placeKey, favorit: favorit, ref: FirebaseData.shared.ref) { resalt in
            switch resalt {
                
            case .success():
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func deletePlace(indexSet: IndexSet) {
        var placeK: PlaceModel!
        for index in indexSet {
            placeK = placeArray[index]
            placeArray.remove(at: index)
        }
        FirebaseAuthDatabase.remowePlace(key: placeK.key, ref: FirebaseData.shared.ref, image: placeK.imageUrl ?? "", gellery: placeK.gellery ?? [])
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}

