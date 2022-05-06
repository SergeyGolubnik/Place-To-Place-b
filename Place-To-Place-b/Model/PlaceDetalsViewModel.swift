//
//  PlaceDenailViewModel.swift
//  Place-To-Place
//
//  Created by СОВА on 29.01.2022.
//

import Foundation
import SDWebImageSwiftUI
import Firebase



class PlaceDetalsViewModel: ObservableObject {
    @Published var name = ""
    @Published var userId = ""
    @Published var key = ""
    @Published var discription = ""
    @Published var imageUrl = ""
    @Published var location = ""
    @Published var avatarNikPlace = ""
    @Published var nikNamePlace = ""
    @Published var favorit = [String]()
    @Published var myFavorit = ""
    @Published var stars = "-"
    @Published var message = false
    @Published var comentArray = [Comment]()
    @Published var imageGeneral = ""
    @Published var imageGellery = [String]()
    @Published var userPlace: Users!
    @Published var userNik = ""
    @Published var updatePlaceNew = false
    @Published var categoryArray = Category()
    @Published var typeName = ""
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
    @Published var moderation = false
   
    
    
    var places: PlaceModel?
    var user: Users?
    var userAll: [Users]?
    
    init(places: PlaceModel?) {
        self.user = FirebaseData.shared.users
        self.places = places
        self.userAll = FirebaseData.shared.userAll
        
    }
    func getPlace() {
        guard let places = places else {
            return
        }
        name = places.name ?? ""
        userId = places.userId
        key = places.key
        moderation = places.moderation ?? true
        discription = places.discription ?? ""
        imageUrl = places.imageUrl ?? ""
        message = places.messageBool ?? true
        typeName = places.typeName ?? ""
        type = places.type ?? ""
        location = places.location ?? ""
        avatarNikPlace = places.avatarNikPlace
        nikNamePlace = places.nikNamePlace
        favorit = places.favorit ?? []
    }
    func starsRating() {
        stars = "-"
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
    func comentPlace() {
        guard let places = places else {return}
        comentArray.removeAll()
        if places.coments != nil {
            var arrayCom = [Comment]()
            for (keyCom, valuesComent) in places.coments! {
                guard let userAll = userAll else {return print("PlaceDetalsViewModel_return_comentPlace()_userAll = userAll")}
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
                        
                        let comment = Comment(userName: user1.lastName ?? "", userUid: keyCom, avatarImage: user1.avatarsURL ?? "", comment: valuesComent, stars: stars)
                        arrayCom.append(comment)
                    }
                }
            }
            comentArray = arrayCom
        }
        
    }
    func getData() {
        imageGellery.removeAll()
        guard let places = places else {return}
        if places.userId != "" {

            guard let userAll = userAll else {
                return
            }
            self.userPlace = userAll.filter {$0.uid == places.userId}.first
           
            
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
        getPlace()
    }
    func moderationPlace(){
        guard let key = places?.key else {return}
        let ref = Database.database().reference(withPath: "user")
        let placeRef = ref.child(key)
        placeRef.updateChildValues([
            "moderation" : moderation
        ]) { error, arg  in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

