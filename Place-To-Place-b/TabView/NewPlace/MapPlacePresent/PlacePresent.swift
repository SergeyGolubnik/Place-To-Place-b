//
//  PlacePresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 01.12.2021.
//

import SwiftUI
import MapKit

struct PlacePresent: Identifiable {
    
    var id = UUID().uuidString
    var placemark: CLPlacemark
}
