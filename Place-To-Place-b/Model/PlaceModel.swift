//
//  PlaceModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import UIKit
import Firebase

struct PlaceModel {
    
    var userId: String
    var name: String?
    var key: String
    var location: String?
    var type: String?
    var rating: [String: Int]?
    var imageUrl: String?
    var latitude: String?
    var deviseToken: String
    var longitude: String?
    var discription: String?
    var switchPlace: String
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
        imageUrl = snapshotVaiue["image"] as? String
        switchPlace = snapshotVaiue["switchPlace"] as! String
        discription = snapshotVaiue["discription"] as? String
        gellery = snapshotVaiue["gellery"] as? [String]
        favorit = snapshotVaiue["favorit"] as? [String]
        date = snapshotVaiue["date"] as? String
        ref = snapshot.ref
    }

}

