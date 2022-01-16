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
//    PlaceDetail
    @Binding var placeDetail: PlaceModel
    @Binding var goDetail: Bool
    
    @StateObject var mapData = MapViewModel()
    @StateObject var data = FirebaseData()
    
    @State var filter = ""
    @State var filterMy = false
    
    @State var tranferCategory = false
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                MapView(placeDetail: $placeDetail, goDetalsBool: $goDetail)
                    .environmentObject(mapData)
                if filter != "", filter != data.user.uid {
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                filter = ""
                                filterMy = false
                            }) {
                                Text("Сброс фильтра")
                                    .font(.caption)
                                
                            }
                            .frame(width: 70, height: 36)
                            .background(Color.blue)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 5, x: 0, y: 0)
                            .padding(.top, 4)
                            .padding(.trailing, 4)
                        }
                        
                        Spacer()
                    }
                }
                
                
            }
            
            .navigationBarColor(uiColorApp)
            .navigationBarItems(leading:
                                    Button(action: {
                filterMy.toggle()
                filter = filterMy ? data.users.uid : ""
            }) {
                Text(filterMy ? "Все" : "Мои")
                    .foregroundColor(Color(.label))
            }
                                    ,trailing:
                                    Button(action: {
                tranferCategory.toggle()
            }) {
                Image("Filtr")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 5)
            })
            
            .navigationBarTitle("Карта", displayMode: .inline)
            
        }.onAppear(perform: {
            
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            DispatchQueue.main.async {
                mapData.rmovePlace(place: data.places)
            }
            data.fetchData()
            
        })
        
            .onChange(of: filter) { value in
                var placeF = data.places
                if value == filter, value != data.users.uid, filter != "" {
                    placeF = data.places.filter {$0.type == filter}
                    mapData.rmovePlace(place: placeF)
                } else if value == data.users.uid, filter != "" {
                    placeF = data.places.filter {$0.userId == filter}
                    mapData.rmovePlace(place: placeF)
                } else {
                    mapData.rmovePlace(place: data.places)
                }
            }
            .onChange(of: data.places, perform: { newValue in
                if data.places == newValue, filter == "" {
                    mapData.rmovePlace(place: data.places)
                }

            })
            .sheet(isPresented: $tranferCategory) {
                CategoryView(enterType: $filter)
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

struct DiamondBackground: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 250, height: 250, alignment: .center)
                .rotationEffect(.degrees(45.0))
        }
    }
}
struct PlaceListMap_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}
struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    @EnvironmentObject var mapDAta: MapViewModel
    @Binding var placeDetail: PlaceModel
    @Binding var goDetalsBool: Bool
    @EnvironmentObject var firebaseModel: FirebaseData
    
    
    
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
