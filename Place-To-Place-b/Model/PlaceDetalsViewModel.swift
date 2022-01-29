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
    @Published var imageGeneral = UIImage()
    @Published var imageGellery = [UIImage]()
    @Published var isLoading = true
    @Published var userPlace: Users!
    @Published var userNik = ""
    @Published var categoryArray = Category()
    @Published var type = ""
    @Published var defaultImage = UIImage(named: "place-to-place-banner")
    @Published var imagePresent = UIImage()
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
        getData()
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
                guard let userAll = userAll else {
                    return
                }

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
    private func imagePhoto() {
        DispatchQueue.main.async {
            guard let places = self.places else {return}
            guard let imageUrl = places.imageUrl else {return
                self.imageGeneral = UIImage(named: "no_image")!
            }
            self.imageGeneral = FirebaseData.shared.getImageUIImage(url: imageUrl)
            
            if places.gellery != nil, places.gellery != [] {
                for imageStringUrl in places.gellery! {
                    self.imageGellery.append(FirebaseData.shared.getImageUIImage(url: imageStringUrl))
                }
            }
            self.isLoading = false
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
        starsRating()
        comentPlace()
        imagePhoto()
    }
    
}

