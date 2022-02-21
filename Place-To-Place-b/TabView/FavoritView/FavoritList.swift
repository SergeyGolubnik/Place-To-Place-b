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
    @State var title: String
    @State var placeArray = [PlaceModel]()
    @State var place: [PlaceModel]
    @State var textMessage = ""
    @State var detailPlaceBool = false
    @StateObject var data = FirebaseData()
    var body: some View {
        
        NavigationView {
            ZStack{
                
                Text(textMessage)
                if placeArray == [PlaceModel]() {
                    Text("У вас не отмеченно любимых мест")
                        .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
                        .navigationBarTitle("Любимые места", displayMode: .inline)
                } else {
                    List{
                        
                        ForEach(placeArray, id: \.id) { item in
                            
                            FavoritCell(imageURL: item.imageUrl ?? "", name: item.name ?? "", location: item.location ?? "", placeRating: item.rating)
                                .onTapGesture {
                                    self.detailPlaceBool = true
                                }
                                .sheet(isPresented: $detailPlaceBool, content: {
                                    PlaceDetals(vm: PlaceDetalsViewModel(places: item, user: data.user, userAll: data.userAll))
                                })
                        }
                        
                        .onDelete { indexSet in
                            var favorit = [String]()
                            var placeKey = ""
                            for index in indexSet {
                                
                                placeKey = placeArray[index].key
                                favorit = (placeArray[index].favorit?.filter {$0 != data.user.uid})!
                                placeArray.remove(at: index)
                            }
                            FirebaseAuthDatabase.updateFavorit(key: placeKey, favorit: favorit, ref: data.ref) { resalt in
                                switch resalt {
                                    
                                case .success():
                                    break
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                    }
                    .listSeparatorStyle(style: .none)
                    
                    .listStyle(PlainListStyle())
                    
                    
                    .navigationBarColor(uiColorApp)
                    .navigationBarTitle(title, displayMode: .inline)
                    .toolbar  {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
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
        .onAppear {
            if title == "Все" {
                placeArray = place.filter { $0.userId == data.user.uid}
            }
            if title == "Любимые места" {
                
                for item in place {
                    if item.favorit != nil {
                        
                        for i in item.favorit! {
                            if i == self.data.user.uid {
                                placeArray.append(item)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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
