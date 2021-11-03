//
//  TabView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//


import SwiftUI

struct TabViewPlace: View {
    @State var newPlace = false
    @State var user: Users?
    @State var selected = 0
    @State var placeD = PlaceModel(key: "", userId: "", switchPlace: "", deviseToken: "")
    @State var goDetail = false
    @State var exitBool = false
    @StateObject var data = FirebaseData()
    @State var place = [PlaceModel]()
    
    var body: some View {
        if exitBool {
            ContentView()
        } else if data.places == [] {
            LoaderView()
        } else {
            ZStack {
                if selected == 0 {
                    PlaceListMap(placeDetail: $placeD, goDetail: $goDetail, place: data.places)
                } else if selected == 1 {
                    FavoritList(deailPlace: $placeD, detailPlaceBool: $goDetail)
                } else if selected == 3 {
                    UserSetings(exitBool: $exitBool)
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
            .environmentObject(data)
            .sheet(isPresented: $goDetail, content: {
                PlaceDetals(place: $placeD, user: data.user)
            })
            .sheet(isPresented: $newPlace, content: {
                    NewPlaceView()
            })
        }
        
    }
}

struct TabViewPlace_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}
struct CurvedShape: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 90))
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 90), radius: 30, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: 90))
        }
        .fill(Color.init(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1)))
        .rotationEffect(.init(degrees: 180))
        
        
    }
}
