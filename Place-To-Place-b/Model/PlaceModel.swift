//
//  PlaceModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import UIKit
import Firebase

struct PlaceModel: Hashable {

    var id = UUID()
    var userId: String
    var name: String?
    var key: String
    var location: String?
    var type: String?
    var rating: [String: Int]?
    var coments: [String: String]?
    var imageUrl: String?
    var latitude: String?
    var deviseToken: String
    var longitude: String?
    var discription: String?
    var switchPlace: String
    var messageBool: Bool?
    var gellery: [String]?
    var favorit: [String]?
    var date: String?
    let ref: DatabaseReference?
    
    
    init(key: String, userId: String, switchPlace: String, deviseToken: String) {
        self.userId = userId
        self.key = key
        self.switchPlace = switchPlace
        self.ref = nil
        self.deviseToken = deviseToken
    }
    

   
    init(snapshot: DataSnapshot) {
        let snapshotVaiue = snapshot.value as! [String: Any]
        userId = snapshotVaiue["userId"] as! String
        name = snapshotVaiue["name"] as? String
        key = snapshotVaiue["key"] as! String
        location = snapshotVaiue["location"] as? String
        latitude = snapshotVaiue["latitude"] as? String
        longitude = snapshotVaiue["Longitude"] as? String
        type = snapshotVaiue["type"] as? String
        deviseToken = snapshotVaiue["deviseToken"] as! String
        rating = snapshotVaiue["rating"] as? [String: Int]
        coments = snapshotVaiue["coments"] as? [String: String]
        imageUrl = snapshotVaiue["image"] as? String
        switchPlace = snapshotVaiue["switchPlace"] as! String
        discription = snapshotVaiue["discription"] as? String
        gellery = snapshotVaiue["gellery"] as? [String]
        favorit = snapshotVaiue["favorit"] as? [String]
        date = snapshotVaiue["date"] as? String
        messageBool = snapshotVaiue["messageBoll"] as? Bool
        ref = snapshot.ref
    }

    init(userId: String, name: String, key: String, location: String, type: String, rating: [String: Int], imageUrl: String, latitude: String?, deviseToken: String, longitude: String?, discription: String?, switchPlace: String, gellery: [String]?, favorit: [String]?, date: String?, messageBool: Bool?) {
        self.userId = userId
        self.name = name
        self.key = key
        self.location = location
        self.type = type
        self.rating = rating
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.deviseToken = deviseToken
        self.longitude = longitude
        self.discription = discription
        self.switchPlace = switchPlace
        self.gellery = gellery
        self.favorit = favorit
        self.date = date
        self.messageBool = messageBool
        self.ref = nil
    }
}

class NewPlaceModel: ObservableObject {
    @Published var userId: String?
    @Published var name = ""
    @Published var key: String?
    @Published var location = ""
    @Published var type = ""
    @Published var imageUrl: String?
    @Published var latitude = ""
    @Published var deviseToken: String?
    @Published var longitude = ""
    @Published var discription = ""
    @Published var switchPlace = "Делится"
    @Published var messageBool = true
    @Published var gellery: [String]?
    @Published var date: String?
    @Published var imageURLtoUI: UIImage?
}
