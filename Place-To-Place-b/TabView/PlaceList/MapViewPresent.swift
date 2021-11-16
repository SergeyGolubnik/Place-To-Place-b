//
//  MapViewPresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 12.11.2021.
//

import SwiftUI
import MapKit


struct MapViewPresent: UIViewRepresentable {
        
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
        
        func makeUIView(context: Context) -> MKMapView {
            
           
            
            let view = mapView
            
           
            
            return view
            
        }
        
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            if self.locationManager.location != nil{
                guard let location = self.locationManager.location?.coordinate else {return}
                mapView.showsUserLocation = true
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.requestWhenInUseAuthorization()
                    if CLLocationManager.locationServicesEnabled() {
                         self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                         self.locationManager.startUpdatingLocation()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            let locValue:CLLocationCoordinate2D = location
                            print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")
                            let coordinate = CLLocationCoordinate2D(
                                latitude: locValue.latitude, longitude: locValue.longitude)
                            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            mapView.setRegion(region, animated: true)
                        })
                    }

            }
                        
        }
        
        
        func makeCoordinator() -> Coordinator {

        }
     
        
        
    
}

