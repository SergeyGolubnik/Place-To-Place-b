//
//  MapViewPresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 01.12.2021.
//

import SwiftUI
import MapKit


struct MapViewPresent: UIViewRepresentable {
    @EnvironmentObject var mapData: MapViewModelPresent
    var place: PlacePresent?
    @Binding var tappBool: Bool
    var places = [PlacePresent]()
    
    func makeCoordinator() -> Coordinator {
        return MapViewPresent.Coordinator(self)
    }
    let mapView = MKMapView()
    
    
    func makeUIView(context: Context) -> MKMapView {
        
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        let longPressed = UILongPressGestureRecognizer(target: context.coordinator,
                                                       action: #selector(context.coordinator.tapHandler(_:)))
        
        
        view.addGestureRecognizer(longPressed)
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        
        
        var mapData = MapViewModelPresent()
        var data: MapViewPresent
        var place: PlacePresent?
        let mapView = MKMapView()
        var gRecognizer = UITapGestureRecognizer()
        init(_ parent: MapViewPresent) {
            self.data = parent
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation.isKind(of: MKUserLocation.self){return nil}
            else{
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                
                return pinAnnotation
            }
        }
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            
            //            self.data.mapData.places.removeAll()
            if (gesture.state == UITapGestureRecognizer.State.ended) {
                return
            }
            let touchPoint = gesture.location(in: gesture.view)
            let newCoordinates = (gesture.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gesture.view)
            
            guard let coordinate = newCoordinates else {return}
            let locationTap = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print(coordinate)
            CLGeocoder().reverseGeocodeLocation(locationTap) { (placemarks, error) -> Void in
                if error != nil {
                    
                    
                    print(error?.localizedDescription ?? "Ошибка")
                    
                } else {
                    
                    if let validPlacemark = placemarks?[0]{
                        
                        self.data.mapData.places = [PlacePresent(placemark: validPlacemark)]
                        self.place = PlacePresent(placemark: validPlacemark)
                        self.data.mapData.place = PlacePresent(placemark: validPlacemark)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.data.mapData.selectPlace()
                            
                            self.data.mapData.selectPlace()
                            
                        }
                    }
                    
                }
                
                
            }
                
                
            }
            
        }
}
