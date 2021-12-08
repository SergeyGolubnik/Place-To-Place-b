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
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @StateObject var dataNewPlace = NewPlaceModel()
    
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
                dataNewPlace.type = enterType
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
