//
//  PlaceDenailViewModel.swift
//  Place-To-Place
//
//  Created by СОВА on 29.01.2022.
//

import Foundation
import SDWebImageSwiftUI



class PlaceDetalsViewModel: ObservableObject {
    @Published var myFavorit = ""
    @Published var stars = "-"
    @Published var comentArray = [Comment]()
    @Published var imageGeneral = ""
    @Published var imageGellery = [String]()
    @Published var userPlace: Users!
    @Published var userNik = ""
    @Published var categoryArray = Category()
    @Published var type = ""
    @Published var defaultImage = UIImage(named: "place-to-place-banner")
    @Published var imagePresent = ""
    @Published var itemImagePresent = [Any]()
    @Published var redactPlace = false
    @Published var messageBool = false
    @Published var navigationBool = false
    @Published var starsBool = false
    @Published var userPlaceBool = false
    @Published var favoritPlaceBool = false
    @Published var shareBool = false
   
    
    
    var places: PlaceModel?
    var user: Users?
    var userAll: [Users]?
    
    init(places: PlaceModel?, user: Users?, userAll: [Users]?) {
        self.user = user
        self.places = places
        self.userAll = userAll
        self.starsRating()
        self.comentPlace()
        self.getData()
        print("PlaceDetalsViewModel ____ imageGellery ______ \(self.imageGellery.count)")
        print("PlaceDetalsViewModel ____ stars ______ \(self.stars)")
        print("PlaceDetalsViewModel ____ comentArray ______ \(self.comentArray.count)")
    }
    private func starsRating() {
        guard let places = places else { return }
        if places.rating != nil {
            var resalt = 0.0
            var starsSumm = 0
            var starsEnty = 0
            guard let rating = places.rating else {return}
            for i in rating {
                starsSumm += i.value
                starsEnty += 1
            }
            resalt = Double(starsSumm) / Double(starsEnty)
            if resalt != 0.0 {
                self.stars = String(format: "%.1f", resalt)
            }
        }
    }
    private func comentPlace() {
        guard let places = places else {return}
        comentArray.removeAll()
        if places.coments != nil {
            var arrayCom = [Comment]()
            for (keyCom, valuesComent) in places.coments! {
                guard let userAll = userAll else {return}
                for user1 in userAll {
                    if user1.uid == keyCom {
                        var stars = 0
                        if places.rating != nil {
                            for (keyStars, stars1) in places.rating! {
                                if keyStars == keyCom {
                                    stars = stars1
                                }
                            }
                        }
                        
                        let comment = Comment(userName: user1.lastName ?? "", userUid: keyCom, avatarImage: FirebaseData.shared.getImageUIImage(url: user1.avatarsURL ?? ""), comment: valuesComent, stars: stars)
                        arrayCom.append(comment)
                    }
                }
            }
            comentArray = arrayCom
        }
        
    }
    private func getData() {
        guard let places = places else {return}
        if places.userId != "" {

            guard let userAll = userAll else {
                return
            }

            for placeUser in userAll {
                if places.userId == placeUser.uid {
                    self.userPlace = placeUser
                    
                }
            }
            
        }

        if places.type != "" {
            for i in categoryArray.categoryArray {
                if i.name == places.type {
                    self.type = i.imageString!
                }
            }
        }
        guard let user = user else {
            return
        }

        if places.favorit != [], places.favorit != nil {
            for i in places.favorit! {
                if i == user.uid {
                    self.myFavorit = i
                }
            }
        }
        if let plaG = places.gellery {
            for i in plaG {
                imageGellery.append(i)
            }
        }

    }
    
}

