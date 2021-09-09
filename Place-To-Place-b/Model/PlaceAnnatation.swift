//
//  PlaceAnnatation.swift
//  Place-To-Place-b
//
//  Created by СОВА on 09.09.2021.
//

import Foundation
import MapKit
import Contacts


class PlaceAnatation: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let discipLine: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    let placeId: String?
    let placeUid: String?
    let favorit: [String]?
    init(
    title: String?,
        locationName: String?,
        discipLine: String?,
        subtitle: String?,
        placeId: String?,
        placeUid: String?,
        favorit: [String]?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.discipLine = discipLine
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.placeId = placeId
        self.placeUid = placeUid
        self.favorit = favorit
        
        super.init()
    }
    
    
    var mapItem: MKMapItem? {
        guard let location = locationName else {
            return nil
        }
        let adresDict = [CNPostalAddressStateKey: location]
        let placemarc = MKPlacemark(coordinate: coordinate, addressDictionary: adresDict)
        
        let mapItem = MKMapItem(placemark: placemarc)
        mapItem.name = title
        return mapItem
    }
    
}
