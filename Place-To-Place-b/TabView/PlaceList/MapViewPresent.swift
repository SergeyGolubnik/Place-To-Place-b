//
//  MapViewPresent.swift
//  Place-To-Place-b
//
//  Created by СОВА on 12.11.2021.
//

import SwiftUI
import MapKit

struct MapViewPresent: UIViewRepresentable {
    @Binding var annotationTitle: String
    @Binding var coordinateLatitude: String
    @Binding var coordinateLongitude: String
    @Binding var regionManager: MKCoordinateRegion
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
                
                let region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                view.setRegion(region, animated: true)
            }
        
        
        
    }
    
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self, annotationTitle: $annotationTitle, coordinateLatitude: $coordinateLatitude, coordinateLongitude: $coordinateLongitude)
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
                        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        regionManager = region
                        mapView.setRegion(region, animated: true)
                    })
                }

        }
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        var mapViewController: MapViewPresent
        var center: CLLocation?
        let placeAnnatationName = "Точка"
        @Binding var annotationTitle: String
        @Binding var coordinateLatitude: String
        @Binding var coordinateLongitude: String
        
        init(_ control: MapViewPresent, annotationTitle: Binding<String>, coordinateLatitude: Binding<String>, coordinateLongitude: Binding<String>) {
            self.mapViewController = control
            self._annotationTitle = annotationTitle
            self._coordinateLatitude = coordinateLatitude
            self._coordinateLongitude = coordinateLongitude
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let annotation = view.annotation
            guard (annotation as? MKPointAnnotation) != nil else { return }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            
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
            self.center = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let geocoder = CLGeocoder()
            // Опрделяем по координатам адрес
            geocoder.reverseGeocodeLocation(self.center!) {[weak self] (placemarks, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                // если нет ошибки то определяем экземпляр адреса
                guard let plasemarks = placemarks else { return }
                
                // имплементируем адреса
                let plasemark = plasemarks.first
                // Почтовый индекс
    //            let postCode = plasemark?.postalCode
                // город
                let cityName = plasemark?.locality
                let subMame = plasemark?.subAdministrativeArea
                // улица
                let streetName = plasemark?.thoroughfare
                // номер дома
                let buidNumber = plasemark?.subThoroughfare
                
                
                // ассинхроно обновляет информацию
                DispatchQueue.main.async {
                    
                    // выводит и состовляет на экран адрес
                    if cityName != nil && streetName != nil && buidNumber != nil {
                        self?.annotationTitle = "\(cityName!), \(streetName!), \(buidNumber!)"
                    } else if streetName != nil && buidNumber != nil {
                        self?.annotationTitle = "\(streetName!), \(buidNumber!)"
                    } else if buidNumber != nil {
                        self?.annotationTitle = "\(buidNumber!)"
                    }  else if subMame != nil {
                        self?.annotationTitle = "\(subMame!)"
                    } else {
                        self?.annotationTitle = ""
                    }
                    print("\(self!.coordinateLatitude), \(self!.annotationTitle), \(String(describing: streetName))")
                    self?.coordinateLatitude = String((self?.center!.coordinate.latitude ?? 0))
                    self?.coordinateLongitude = String((self?.center!.coordinate.longitude ?? 0))
                }
                annotation.title = self?.placeAnnatationName
                annotation.subtitle = self?.annotationTitle
            }
            mapViewController.annotations.append(annotation)
        }
    }
    
}


