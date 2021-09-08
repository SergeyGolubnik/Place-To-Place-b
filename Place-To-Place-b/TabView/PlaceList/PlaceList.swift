//
//  PlaceList.swift
//  Place-To-Place-b
//
//  Created by СОВА on 07.09.2021.
//

import SwiftUI

struct PlaceList: View {
    
    @EnvironmentObject var viewModel: FirebaseData
    
    var body: some View {
        
        NavigationView {
            
            ScrollView{
                VStack(spacing: 20){
                    ForEach(viewModel.places, id: \.id) { item in
                        Text(item.name ?? "ytn")
                    }
                }
            }
            .navigationBarColor(#colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 0.5254901961, alpha: 1))
            .navigationBarTitle("ghkknkj", displayMode: .inline)
            
            
            
        }
        
    }
    
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}


struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}
extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }

}
