//
//  PlaceListMap.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI
import MapKit

struct PlaceListMap: View {
    @State var listBool = false
    @State var locationManager = CLLocationManager()
//    PlaceDetail
    @Binding var placeDetailViewModel: PlaceDetalsViewModel
    @Binding var placeDetail: PlaceModel
    @State var goDetail = false
    @Binding var message: String
    
    @StateObject var mapData = MapViewModel()
    @StateObject var data = FirebaseData()
    
    @State var filter = ""
    @State var filterMy = false
    
    @State var strungType = ""
    
    @State var tranferCategory = false
    @State var placeF = [PlaceModel]()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                if !listBool {
                    
                Map(coordinateRegion: $mapData.region, showsUserLocation: true, annotationItems: placeF) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        
                        AnnatatonPin(image: place.typeName ?? "")
                           
                                        .onTapGesture {
                                            placeDetail = place
                                            self.message = "Прошла транзакция"
                                            self.placeDetailViewModel = PlaceDetalsViewModel(places: place)
                                            goDetail = true
                                        }
                    }
                }
                
//                    MapView(placeDetailViewModel: $placeDetailViewModel, placeDetail: $placeDetail, goDetalsBool: $goDetail, message: $message)
//                        .environmentObject(mapData)
                } else {
                    
                    ListPlace(placeDetailViewModel: $placeDetailViewModel, filter: $filter)
                            .padding(.bottom, 55)
                    
                    
                }
                
                if filter != "", filter != data.users.uid {
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
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            listBool.toggle()
                            filter = ""
                        } label: {
                            Image(systemName: listBool ? "map" : "filemenu.and.cursorarrow")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                                .padding()
                        }
                        
                    }.padding(.bottom,70)
                }

                
            }
            
            .navigationBarColor(uiColorApp)
            .navigationBarItems(leading:
                                    Button(action: {
                filterMy.toggle()
                filter = filterMy ? data.users.uid : ""
            }) {
                Text(filterMy ? "Все" : "Мои")
                    .foregroundColor(.black)
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
                mapData.rmovePlace(place: data.places)
            data.fetchData()
        })
        
            .onChange(of: filter) { value in
                placeF = data.places
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
                    placeF = data.places
                }

            })
            .sheet(isPresented: $tranferCategory) {
                CategoryView(enterType: $filter, imageString: $strungType)
            }
            .sheet(isPresented: $goDetail, content: {
                    PlaceDetals(vm: placeDetailViewModel)
            })
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

struct PlaceListMap_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace().preferredColorScheme(.dark)
        TabViewPlace()
    }
}
struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    @EnvironmentObject var mapDAta: MapViewModel
    @Binding var placeDetailViewModel: PlaceDetalsViewModel
    @Binding var placeDetail: PlaceModel
    @Binding var goDetalsBool: Bool
    @Binding var message: String
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
        Coordinator(self, placeDetail: $placeDetail, goDetalsBool: $goDetalsBool, firebaseData: firebaseModel, placeDetailViewModel: $placeDetailViewModel, message: $message)
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var firebaseModel: FirebaseData
        @Binding private var placeDetailViewModel: PlaceDetalsViewModel
        @Binding private var placeDetail: PlaceModel
        @Binding private var goDetalsBool: Bool
        @Binding private var message: String
        var parent: MapView
        init(_ parent: MapView, placeDetail: Binding<PlaceModel>, goDetalsBool: Binding<Bool>, firebaseData: FirebaseData, placeDetailViewModel: Binding<PlaceDetalsViewModel>, message: Binding<String>) {
            self.parent = parent
            self._placeDetail = placeDetail
            self._goDetalsBool = goDetalsBool
            self.firebaseModel = firebaseData
            self._placeDetailViewModel = placeDetailViewModel
            self._message = message
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? PlaceModel else {return nil}
            
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
            guard let place = view.annotation as? PlaceModel else {return}
            self.placeDetail = place
            self.goDetalsBool = true
            self.message = "Прошла транзакция"
            self.placeDetailViewModel = PlaceDetalsViewModel(places: place)
        }
    }
    
    
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 5000, longitudinalMeters: 5000)
    @Published var latitude: CGFloat!
    func rmovePlace(place: [PlaceModel]) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(place)
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
        self.latitude = location.coordinate.latitude
    }
}
