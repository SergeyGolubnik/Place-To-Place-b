//
//  AnnatatonPin.swift
//  Place-To-Place
//
//  Created by СОВА on 14.03.2022.
//

import SwiftUI

struct AnnatatonPin: View {
    @StateObject var category = Category()
    @Binding var placeDetailViewModel: PlaceDetalsViewModel
    @Binding var place: PlaceModel
    @State var goDetail = false
    @State var popover = false
    var body: some View {
        VStack(spacing: 0){
            VStack{
                    AnnatatonPinView(type: place.type ?? "")
                
            }
            .padding(.bottom, 100)
        }
       
    }
}

struct AnnatatonPin_Previews: PreviewProvider {
    static var previews: some View {
        let place = PlaceModel(userId: "", name: "Тест", key: "", nikNamePlace: "",avatarNikPlace: "", phoneNumber: "", phoneNumberArray: nil, location: "Мсква  ул Правды 27с7", type: "Бары и пабы", rating: ["dnnjnjj": 4], coments: ["GhNLVCg74wcJ5P4bgjQMcuzve2n1":"Дополнительный аргумент комментарии в вызове"], imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/PlacePhoto%2F-MqoHaLiofZLQ9R9cWV4?alt=media&token=8410a88a-5e95-45fc-9c65-54fdabdafafd", latitude: "55.7522", deviseToken: "", longitude: "37.6156", discription: "Координаты (широта и долгота) определяют положение точки на поверхности Земли.", switchPlace: "Делится", gellery:[ "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace20EE74AE-8579-434E-A0F1-B8ABFBCC15151639477897.611114?alt=media&token=aa3b734f-fa79-4d16-9c81-50fa75476206", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-laceF5E410C8-E2EE-41BC-8F1E-6626B7391A431639477902.93265?alt=media&token=ed19284c-00e3-42f0-abb4-499d9585f54c", "https://firebasestorage.googleapis.com:443/v0/b/sergeygolubnik-place-to-place.appspot.com/o/gellery%2Fplace-to-lace6A31128D-02DC-41C4-92AE-24300C65849E1639477909.47857?alt=media&token=a1505f77-d6db-4a25-a56e-29040e799dde"], favorit: nil, date: nil, messageBool: false, moderation: false)
        AnnatatonPin(placeDetailViewModel: .constant(PlaceDetalsViewModel(places: nil)), place: .constant( place))
    }
}
struct Triangle : Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}
import SwiftUI

struct AnnatatonPinView: View {
    @StateObject var category = Category()
    @State var image = "kinder"
    @State var type: String
    var body: some View {
            
            ZStack{
                Triangle()
                    .foregroundColor(colorApp)
                    .offset(y: 35)
                    .frame(width: 50, height: 50, alignment: .center)
                Circle()
                    .frame(width: 52, height: 52)
                Circle()
                    .foregroundColor(colorApp)
                    .frame(width: 50, height: 60)
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
            }
            
            
            
        .shadow(radius: 3)
        .onAppear {
            for input in category.categoryArray {
                if input.name == type {
                    image = input.imageString ?? ""
                }
            }
        }
    }
}
