//
//  PlaceListMap.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI
import MapKit

struct PlaceListMap: View {
    
    @Binding var placeDetail: PlaceModel
    
    @Binding var goDetail: Bool
    @State var place = [PlaceModel]()
    @State var filter = ""
    var body: some View {
        
        NavigationView {
            ZStack {
                MapView(placeDetail: $placeDetail, goDetalsBool: $goDetail, filter: filter)
                Button(action: {
                    filter = "Гостиницы"
                }, label: {
                    Text("Button")
                })
            }
            
                .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
                .navigationBarTitle("Карта", displayMode: .inline)
        }
    }
}

//struct PlaceListMap_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListMap(placeDetail: .constant(PlaceModel(key: "", userId: "", switchPlace: "", deviseToken: "")), goDetail: .constant(false))
//    }
//}
struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    
    @Binding var placeDetail: PlaceModel
    @Binding var goDetalsBool: Bool
    @EnvironmentObject var firebaseModel: FirebaseData
    var filter: String
    
    
    var initalisator = ""
    
    
    
    func makeUIView(context: Context) -> MKMapView {
        
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        var place = [PlaceModel]()
        if filter != "" {
            place = firebaseModel.places.filter {$0.type == filter}
        } else {
            place = firebaseModel.places
        }
        var array = [PlaceAnatation]()
        for anatacionPL in place {
            guard let latitude = Double(anatacionPL.latitude!), let longitude = Double(anatacionPL.longitude!) else {continue}
            let placeAnatation = PlaceAnatation(title: anatacionPL.name,
                                                locationName: anatacionPL.name,
                                                discipLine: anatacionPL.name,
                                                subtitle: anatacionPL.type,
                                                placeId: anatacionPL.key,
                                                placeUid: anatacionPL.userId,
                                                favorit: anatacionPL.favorit,
                                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            array.append(placeAnatation)
        }
       
            mapView.addAnnotations(array)
        
        
        
        return mapView
        
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        
        uiView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate {
                    let coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    uiView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, placeDetail: $placeDetail, goDetalsBool: $goDetalsBool, firebaseData: firebaseModel)
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var firebaseModel: FirebaseData
        
        @Binding private var placeDetail: PlaceModel
        @Binding private var goDetalsBool: Bool
        var parent: MapView
        init(_ parent: MapView, placeDetail: Binding<PlaceModel>, goDetalsBool: Binding<Bool>, firebaseData: FirebaseData) {
            self.parent = parent
            self._placeDetail = placeDetail
            self._goDetalsBool = goDetalsBool
            self.firebaseModel = firebaseData
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? PlaceAnatation else {return nil}
            
            let identifer = "placeAnatanion"
            let view: MKPinAnnotationView
            
            if let dequeuedVieew = mapView.dequeueReusableAnnotationView(withIdentifier: "placeAnatanion") as? MKPinAnnotationView {
                dequeuedVieew.annotation = annotation
                view = dequeuedVieew
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifer)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -9, y: 0)
                
                
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let place = view.annotation as? PlaceAnatation else {return}
            let idAnatation = place.placeId!
            if idAnatation != "" {
                for item in firebaseModel.places {
                    if item.key == idAnatation {
                        placeDetail = item
                        goDetalsBool = true
                        
                    }
                    
                }
                
            }
            
        }
    }
}
