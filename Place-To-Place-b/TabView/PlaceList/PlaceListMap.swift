//
//  PlaceListMap.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI
import MapKit

struct PlaceListMap: View {
    @State var idann = ""
    @State var place = [PlaceModel]()
    var body: some View {
        NavigationView {
            MapView(idAnn: $idann)
                .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
                .navigationBarTitle(idann, displayMode: .inline)
        }
    }
}

struct PlaceListMap_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListMap()
    }
}
struct MapView: UIViewRepresentable {
    @Binding var idAnn: String
    @EnvironmentObject var firebaseModel: FirebaseData
    var annatationArray = [PlaceAnatation]()
    var initalisator = ""
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        var array = [PlaceAnatation]()
        for anatacionPL in self.firebaseModel.places {
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
        context.coordinator.idAnatation = idAnn
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate {
       var idAnatation = ""
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
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
            idAnatation = place.placeId!
        }
    }
}
