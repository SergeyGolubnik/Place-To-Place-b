//
//  MapViewPresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 12.11.2021.
//

import SwiftUI
import MapKit

struct MapViewPresent: UIViewRepresentable {
    @State var annotations = [PlaceAnatation]()
    let locationManager = CLLocationManager()
    var mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        localKlien()
        let view = mapView
            view.delegate = context.coordinator
            let longPressed = UILongPressGestureRecognizer(target: context.coordinator,
                                                           action: #selector(context.coordinator.addPinBasedOnGesture(_:)))
            view.addGestureRecognizer(longPressed)
            return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = context.coordinator
        view.removeAnnotations(view.annotations)
        view.addAnnotations(annotations)
        if annotations.count == 1 {
            let coords = annotations.first!.coordinate
            
            let region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            view.setRegion(region, animated: true)
        }
        
    }
    
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    func localKlien() {
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
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        var mapViewController: MapViewPresent
        
        
        
        init(_ control: MapViewPresent) {
            self.mapViewController = control
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let annotation = view.annotation
            guard (annotation as? MKPointAnnotation) != nil else { return }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            //Custom View for Annotation
            let identifier = "Placemark"
            if  let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                let button = UIButton(type: .infoDark)
                annotationView.rightCalloutAccessoryView = button
                return annotationView
            }
        }
        
        @objc func addPinBasedOnGesture(_ gestureRecognizer:UIGestureRecognizer) {
            if (gestureRecognizer.state == UITapGestureRecognizer.State.began) {
                mapViewController.annotations.removeAll()
            } else if (gestureRecognizer.state == UITapGestureRecognizer.State.ended) {
                return
            }
            mapViewController.annotations = [PlaceAnatation]()
            let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let newCoordinates = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
            let annotation = PlaceAnatation(title: "", locationName: "", discipLine: "", subtitle: "", placeId: "", placeUid: "", favorit: [], coordinate: newCoordinates!)
            guard let _newCoordinates = newCoordinates else { return }
            annotation.coordinate = _newCoordinates
            
            mapViewController.annotations.append(annotation)
        }
    }
    
}


