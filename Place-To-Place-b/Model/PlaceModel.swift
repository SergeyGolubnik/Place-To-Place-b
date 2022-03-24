//
//  PlaceModel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import UIKit
import Firebase
import MapKit
import Contacts

class PlaceModel: NSObject, Identifiable, MKAnnotation {
    
//    static func == (lhs: PlaceModel, rhs: PlaceModel) -> Bool {
//        return lhs.userId == rhs.userId
//    }
    

    var id = UUID()
    var userId: String
    var name: String?
    var nikNamePlace: String
    var avatarNikPlace: String
    var phoneNumber: String
    var phoneNumberArray: [String]?
    var key: String
    var location: String?
    var type: String?
    var typeName: String?
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
    var moderation: Bool?
    let ref: DatabaseReference?
    
    
    init(key: String, userId: String, phoneNumber: String, nikNamePlace: String, avatarNikPlace: String, switchPlace: String, deviseToken: String) {
        self.userId = userId
        self.key = key
        self.nikNamePlace = nikNamePlace
        self.avatarNikPlace = avatarNikPlace
        self.phoneNumber = phoneNumber
        self.switchPlace = switchPlace
        self.ref = nil
        self.deviseToken = deviseToken
    }
    

   
    init(snapshot: DataSnapshot) {
        let snapshotVaiue = snapshot.value as! [String: Any]
        userId = snapshotVaiue["userId"] as! String
        name = snapshotVaiue["name"] as? String
        key = snapshotVaiue["key"] as! String
        nikNamePlace = snapshotVaiue["nikNamePlace"] as! String
        avatarNikPlace = snapshotVaiue["avatarNikPlace"] as! String
        phoneNumber = snapshotVaiue["phoneNumber"] as! String
        phoneNumberArray = snapshotVaiue["phoneNumberArray"] as? [String]
        location = snapshotVaiue["location"] as? String
        latitude = snapshotVaiue["latitude"] as? String
        longitude = snapshotVaiue["Longitude"] as? String
        type = snapshotVaiue["type"] as? String
        typeName = snapshotVaiue["typeName"] as? String
        deviseToken = snapshotVaiue["deviseToken"] as! String
        rating = snapshotVaiue["rating"] as? [String: Int]
        coments = snapshotVaiue["coments"] as? [String: String]
        imageUrl = snapshotVaiue["image"] as? String
        switchPlace = snapshotVaiue["switchPlace"] as! String
        discription = snapshotVaiue["discription"] as? String
        gellery = snapshotVaiue["gellery"] as? [String]
        favorit = snapshotVaiue["favorit"] as? [String]
        date = snapshotVaiue["date"] as? String
        messageBool = snapshotVaiue["messageBool"] as? Bool
        moderation = snapshotVaiue["moderation"] as? Bool
        ref = snapshot.ref
    }

    init(userId: String, name: String, key: String, nikNamePlace: String, avatarNikPlace: String, phoneNumber: String, phoneNumberArray: [String]?, location: String, type: String, typeName: String?, rating: [String: Int], coments: [String: String]?, imageUrl: String, latitude: String?, deviseToken: String, longitude: String?, discription: String?, switchPlace: String, gellery: [String]?, favorit: [String]?, date: String?, messageBool: Bool?, moderation: Bool?) {
        self.userId = userId
        self.name = name
        self.key = key
        self.nikNamePlace = nikNamePlace
        self.avatarNikPlace = avatarNikPlace
        self.phoneNumber = phoneNumber
        self.phoneNumberArray = phoneNumberArray
        self.location = location
        self.type = type
        self.typeName = typeName
        self.rating = rating
        self.coments = coments
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
        self.moderation = moderation
        self.ref = nil
        
    }
    var title: String? { return name ?? ""}
    var locationName: String {return name ?? ""}
    var discipLine: String {return name ?? ""}
    var subtitle: String? {return type}
    var placeId: String? {return key}
    var placeUid: String? {return userId}
    var coordinate: CLLocationCoordinate2D {
        let latitude = Double(latitude ?? "") ?? 0.0
        let longitude = Double(longitude ?? "") ?? 0.0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var mapItem: MKMapItem? {
        guard let location = name else {
            return nil
        }
        let adresDict = [CNPostalAddressStateKey: location]
        let placemarc = MKPlacemark(coordinate: coordinate, addressDictionary: adresDict)
        
        let mapItem = MKMapItem(placemark: placemarc)
        mapItem.name = locationName
        return mapItem
    }
    
}


struct Comment: Hashable {
    var userName: String
    var userUid: String
    var avatarImage: String
    var comment: String
    var stars: Int
}
