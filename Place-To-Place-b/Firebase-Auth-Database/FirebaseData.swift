//
//  FirebaseData.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import Foundation
import Firebase

class FirebaseData: ObservableObject {
    private var ref: DatabaseReference!
    private var user: Users!
    @Published var places = [PlaceModel]()
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        ref = Database.database().reference(withPath: "user")
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
//        places.removeAll()
//        placesRestar.removeAll()
        ref.observe(.value) { [weak self] (snapshot) in
            var array = [PlaceModel]()
            for item in snapshot.children {
                let placeModel = PlaceModel(snapshot: item as! DataSnapshot)
                if placeModel.switchPlace == "Приватно" && self?.user.uid != placeModel.userId {} else {
                    if placeModel.userId == self?.user.uid {
//                        if self?.userToken != "", placeModel.deviseToken != self?.userToken, self?.userToken != nil {
//                            guard let userUid = self?.user.uid else {return}
//                            UserLoginRegister.updateToken(key: placeModel.key, switchPlace: placeModel.switchPlace, userId: userUid, newToken: (self?.userToken)!, ref: (self?.ref)!)
//                            array.append(placeModel)
//                        }
                    }
                    array.append(placeModel)
                }
            }
            
            self?.places = array
//            if self?.segmentedControlOutlet.selectedSegmentIndex == 1 {
//                self?.places = (self?.places.filter{ $0.userId == self?.user.uid })!
//            }
//            if self?.favorit ?? false {
//                var arrayFavorit = [PlaceModel]()
//                self?.favoritFilter.tintColor = .red
//                for item in self!.places {
//                    if item.favorit != nil {
//                        for i in item.favorit! {
//                            if i == self?.user.uid {
//                                arrayFavorit.append(item)
//                            }
//                        }
//                    }
//                }
//                self?.places = arrayFavorit
//            }
//            if self?.annotationId != "" {
//                self?.places = (self?.places.filter{ $0.key == self?.annotationId })!
//                self?.segmentedControlOutlet.alpha = 0
//                self?.segmentedControlOutlet.isEnabled = false
//                self?.navigationItem.leftBarButtonItem = nil
//                self?.navigationItem.rightBarButtonItem = nil
//            }
//            self?.placesRestar = array
//            self?.tableView.refreshControl?.endRefreshing()
//            self?.tableView.reloadData()
        }



    }
}
