//
//  CategoryView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 23.09.2021.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var enterType: String
    @State var categoryArray = Category()
    let category: [CategoryModel] = [
        CategoryModel(imageString: "bar", name: "Бары и пабы"),
        CategoryModel(imageString: "restoran", name: "Рестораны и кафе"),
        CategoryModel(imageString: "fasfud", name: "Фасфуд"),
        CategoryModel(imageString: "salon", name: "Красота"),
        CategoryModel(imageString: "marcet", name: "Магазины"),
        CategoryModel(imageString: "tc", name: "Торговые центры"),
        CategoryModel(imageString: "kinder", name: "Для детей"),
        CategoryModel(imageString: "hotel", name: "Гостиницы"),
        CategoryModel(imageString: "bisnes", name: "Бизнес"),
        CategoryModel(imageString: "dicovery", name: "Места культуры"),
        CategoryModel(imageString: "parc", name: "Парки и скверы"),
        CategoryModel(imageString: "razvlechenia", name: "Развлечения"),
        CategoryModel(imageString: "servis", name: "Сервис"),
        CategoryModel(imageString: "servisAuto", name: "Автосервис"),
        CategoryModel(imageString: "direct", name: "Объявления"),
        CategoryModel(imageString: "adalt", name: "Для взрослых"),
        CategoryModel(imageString: "tinder", name: "Для общения")
    ]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            Color.hex("FEE086")
                .ignoresSafeArea()
            VStack {
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 12, alignment: .center)
                    .padding(.top)
                    .padding(.bottom, 20)
                ScrollView {
                    LazyVGrid (columns: columns){
                        ForEach(categoryArray.categoryArray, id: \.id) { cat in
                            CategoryCart(cart: $enterType, image: cat.imageString!, title: cat.name!)
                        }
                    }
                    
                }
            }
            .onChange(of: enterType) { newValue in
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(enterType: .constant(""))
    }
}
struct CategoryCart: View {
    @Binding var cart: String
    @State var image: String
    @State var title: String
    
    var body: some View {
        
        VStack {
            Image(image)
                .resizable()
            
                .frame(width: 90, height: 90)
            
            Text(title)
                .font(.caption2)
                .multilineTextAlignment(.center)
            
            
        }
        .frame(width: 105, height: 105)
        .padding(5)
//        .background(Color.gray)
        .cornerRadius(10)
        .onTapGesture {
            cart = title
        }
    }
}
struct CategoryCart_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCart(cart: .constant(""), image: "bar", title: "Bar")
    }
}
