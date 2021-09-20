//
//  PlaceListMap.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI
import MapKit

struct PlaceListMap: View {
    @State var locationManager = CLLocationManager()
    @Binding var placeDetail: PlaceModel
    @StateObject var mapData = MapViewModel()
    @Binding var goDetail: Bool
    @State var place = [PlaceModel]()
    @State var filter = ""
    var body: some View {
        
        NavigationView {
            ZStack {
                MapView(placeDetail: $placeDetail, goDetalsBool: $goDetail, filter: filter)
                    .environmentObject(mapData)
                VStack {
                    Button(action: {
                        filter = "Гостиницы"
                        var placeF = [PlaceModel]()
                        if filter != "" {
                            placeF = place.filter {$0.type == filter}
                            mapData.rmovePlace(place: placeF)
                        } else {
                            placeF = place
                            mapData.rmovePlace(place: placeF)
                        }
                    }, label: {
                        Text("Button")
                })
                    Button(action: {
                        filter = ""
                        var placeF = [PlaceModel]()
                        if filter != "" {
                            placeF = place.filter {$0.type == filter}
                            mapData.rmovePlace(place: placeF)
                        } else {
                            placeF = place
                            mapData.rmovePlace(place: placeF)
                        }
                    }, label: {
                        Text("waevfw")
                    })
                }
                
            }
            
            .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
            .navigationBarTitle("Карта", displayMode: .inline)
        }.onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            mapData.rmovePlace(place: place)
            
        })
    }
    
    
}

//struct PlaceListMap_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListMap(placeDetail: .constant(PlaceModel(key: "", userId: "", switchPlace: "", deviseToken: "")), goDetail: .constant(false))
//    }
//}
struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    @EnvironmentObject var mapDAta: MapViewModel
    @Binding var placeDetail: PlaceModel
    @Binding var goDetalsBool: Bool
    @EnvironmentObject var firebaseModel: FirebaseData
    @State var filter: String
    
    
    var initalisator = ""
    
    
    
    func makeUIView(context: Context) -> MKMapView {
        
        let view = mapDAta.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
        
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
       
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

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    var firebaseModel: FirebaseData!
    @Published var region: MKCoordinateRegion!
    
    func rmovePlace(place: [PlaceModel]) {
        
        mapView.removeAnnotations(mapView.annotations)
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
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
//        case .denied:
            //alert
//            permissionDenited.toggle()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        self.mapView.setRegion(self.region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
    }
}
