//
//  TabView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//


import SwiftUI

struct TabViewPlace: View {

    @State var newPlace = false
    @State var selected = 0
    @State var placeDetailViewModel = PlaceDetalsViewModel(places: nil)
    @State var placeD = PlaceModel(key: "", userId: "", phoneNumber: "", nikNamePlace: "", avatarNikPlace: "", switchPlace: "", deviseToken: "")
    @State var exitBool = false
    @State var message = ""
    @StateObject var data = FirebaseData()
    
    @State var categoryArray = Category()
    
    var body: some View {
        if exitBool {
            ContentView()
        } else if data.places == [] {
            LoaderView()
        } else {
            ZStack {
                Text(message)
//                if selected == 0 {
                PlaceListMap(placeDetailViewModel: $placeDetailViewModel, placeDetail: $placeD, message: $message)
//                }
                if selected == 1 {
                    FavoritList(placeDetailViewModel: $placeDetailViewModel, title: "Любимые места",  place: data.places)
                } else if selected == 3 {
                    UserSetings(place: data.places, user: $data.myUser, exitBool: $exitBool)
                } else if selected == 2 {
                    MainMessagesView() 
                }
                VStack{
                    
                    Spacer()
                    
                    ZStack{
                        HStack{
         
                            Button(action: {
                                self.selected = 0
                            }) {
                                Image(systemName: self.selected == 0 ? "location.circle.fill" : "location.circle")
                                    .font(.system(size: 25))
                            }.foregroundColor(self.selected == 0 ? .black : .gray)
                            Spacer(minLength: 12)
                            Button(action: {
                                self.selected = 1
                            }) {
                                Image(systemName: self.selected == 1 ? "heart.fill" : "heart")
                                    .font(.system(size: 25))
                            }.foregroundColor(self.selected == 1 ? .black : .gray)
                            Spacer().frame(width: 110)
                            Button(action: {
                                self.selected = 2
                            }) {
                                Image(systemName: self.selected == 2 ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
                                    .font(.system(size: 25))
                            }.foregroundColor(self.selected == 2 ? .black : .gray)
                            Spacer(minLength: 12)
                            Button(action: {
                                self.selected = 3
                            }) {
                                Image(systemName: self.selected == 3 ? "person.circle.fill" : "person.circle")
                                    .font(.system(size: 25))
                            }.foregroundColor(self.selected == 3 ? .black : .gray)
                        }
                        .padding()
                        .padding(.horizontal, 10)
                        .background(CurvedShape()
                                        .ignoresSafeArea())
                        Button(action: {
                            
                            self.newPlace = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 50))
                                .padding(2)
                        }
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(y: -22)
                    }
                }
                
            }
            .onAppear(perform: {
                data.examenationDeviseTocen()
            })
            .environmentObject(data)
            
          
            .sheet(isPresented: $newPlace, content: {
                NewPlaceView(mv: ModelNewPlaceView(place: nil, user: data.myUser))
            })
        }
            
    }
}

struct TabViewPlace_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace().preferredColorScheme(.dark)
        TabViewPlace()
    }
}
struct CurvedShape: View {
    var body: some View {
        GeometryReader{ geo in
            
            Path { path in
                path.move(to: CGPoint(x: geo.size.width - geo.size.width, y: geo.size.height - geo.size.height))
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height - geo.size.height))
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height - 7))
//                path.addArc(center: CGPoint(x: geo.size.width / 2, y: geo.size.height - 7), radius: 30, startAngle: .zero, endAngle: .init(degrees: geo.size.width - 18), clockwise: true)
                path.addLine(to: CGPoint(x: geo.size.width - geo.size.width, y: geo.size.height - 7))
            }
            .fill(Color.init(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1)))
            .rotationEffect(.init(degrees: 180))
            
            
        }
    }
}
