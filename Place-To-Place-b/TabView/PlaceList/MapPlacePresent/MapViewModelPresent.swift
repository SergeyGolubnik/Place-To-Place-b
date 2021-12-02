//
//  MapViewModelPresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 01.12.2021.
//

import SwiftUI
import MapKit
import CoreLocation

// All Map Data Goes Here....

class MapViewModelPresent: NSObject,ObservableObject,CLLocationManagerDelegate {
    
    @Published var adress = ""
    
    
    @Published var mapView = MKMapView()
    
    // Region...
    @Published var region : MKCoordinateRegion!
    // Based On Location It Will Set Up....
    
    // Alert...
    @Published var permissionDenied = false
    
    // Map Type...
    @Published var mapType : MKMapType = .standard
    
    // SearchText...
    @Published var searchTxt = ""
    
    // newPlace info
    @Published var annotationTitle = ""
    @Published var coordinateLatitude = ""
    @Published var coordinateLongitude = ""
    
    // Searched Places...
    @Published var places : [PlacePresent] = []
    @Published var place: PlacePresent!
    
    // Updating Map Type...
    
    func updateMapType(){
        
        if mapType == .standard{
            mapType = .hybrid
            mapView.mapType = mapType
        }
        else{
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // Focus Location...
    
    func focusLocation(){
        
        guard let _ = region else{return}
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    // Search Places...
    
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTxt
        
        // Fetch...
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else{return}
            
            self.places = result.mapItems.compactMap({ (item) -> PlacePresent? in
                return PlacePresent(placemark: item.placemark)
            })
        }
    }
    
    // Pick Search Result...
    
    func selectPlace(){
        
        // Showing Pin On Map....
        
        searchTxt = ""
        
        guard let place = place else {
            return
        }
        let plasemark = place.placemark
        guard let coordinate = place.placemark.location?.coordinate else{return}
        // имплементируем адреса
        
        
        // Почтовый индекс
//            let postCode = plasemark?.postalCode
        // город
        let cityName = plasemark.locality
        let subMame = plasemark.subAdministrativeArea
        // улица
        let streetName = plasemark.thoroughfare
        // номер дома
        let buidNumber = plasemark.subThoroughfare
        
        
        // ассинхроно обновляет информацию
        DispatchQueue.main.async {
            
            // выводит и состовляет на экран адрес
            if cityName != nil && streetName != nil && buidNumber != nil {
                self.annotationTitle = "\(cityName!), \(streetName!), \(buidNumber!)"
            } else if streetName != nil && buidNumber != nil {
                self.annotationTitle = "\(streetName!), \(buidNumber!)"
            } else if buidNumber != nil {
                self.annotationTitle = "\(buidNumber!)"
            }  else if subMame != nil {
                self.annotationTitle = "\(subMame!), \(self.adress)"
            } else {
                self.annotationTitle = ""
            }
            print(self.annotationTitle)
            self.coordinateLatitude = String((coordinate.latitude))
            self.coordinateLongitude = String((coordinate.longitude))
        }
        
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ?? "No Name"
        let adres = place.placemark.thoroughfare
        adress = adres ?? "Адрес отсутсвует"
        // Removing All Old Ones...
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(pointAnnotation)
        
        // Moving Map To That Location...
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Checking Permissions...
        
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting....
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permissin Given...
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error....
        print(error.localizedDescription)
    }
    
    // Getting user Region....
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        // Updating Map....
        self.mapView.setRegion(self.region, animated: true)
        
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    
}
