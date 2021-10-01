//
//  StarsRatingView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 28.09.2021.
//

import SwiftUI
import FirebaseAuth

struct StarsRatingView: View {
    @State var placeModel: PlaceModel?
    @State var userPlace: Users?
    @State var user: Users?
    @Binding var starsBoolView: Bool
    @State private var rating: Int?
    @State var comets = ""
    private func starsType(index: Int) -> String {
        if let rating = rating {
            return index <= rating ? "filledStar" : "emptyStar"
        } else {
            return "emptyStar"
        }
    }
    var body: some View {
        VStack{
            HStack{
                Text("Оцените место")
                    .font(.title)
                    .padding()
            }
            HStack{
                ForEach(1...5, id: \.self) {index in
                    Image(self.starsType(index: index))
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            self.rating = index
                        }
                }
            }
            VStack{
                HStack{
                    TextEditor(text: $comets)
                        .cornerRadius(5)
                        .padding()
                        .frame(height: 200)
                        
                }
                .shadow(radius: 3)
                Button(action: {
                    if rating != nil, userPlace != nil, user != nil {
                        
                        var newRating: [String: Int] = [:]
                        
                        if placeModel?.rating == nil {
                            placeModel?.rating = [user!.uid: rating!]
                            newRating = (placeModel?.rating)!
                        }else {
                            placeModel?.rating![user!.uid] = rating
                            newRating = (placeModel?.rating)!
                        }
                        FirebaseAuthDatabase.aploadRating(key: placeModel!.key, rating: newRating, ref: FirebaseData.shared.ref) { resalt in
                            switch resalt {
                            case .success(_): break
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                    if comets != "", userPlace != nil, user != nil {
                        var newComets: [String: String] = [:]
                        if placeModel?.coments == nil {
                            placeModel?.coments = [user!.uid: comets]
                            newComets = (placeModel?.coments)!
                        }else {
                            placeModel?.coments![user!.uid] = comets
                            newComets = (placeModel?.coments)!
                        }
                        
                        FirebaseAuthDatabase.aploadComents(key: placeModel!.key, coments: newComets, ref: FirebaseData.shared.ref) { resalt in
                            switch resalt {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success():
                                break
                            }
                        }
                    }
                    starsBoolView = false
                }) {
                    Text("Сохранить")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                    
                }
            }
            .background(Color.clear)
        }
        
        .onAppear {
            
            guard let currentUser = Auth.auth().currentUser else {return}
            user = Users(user: currentUser)
        }
    }
        
}

struct StarsRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StarsRatingView(starsBoolView: .constant(false))
    }
}
