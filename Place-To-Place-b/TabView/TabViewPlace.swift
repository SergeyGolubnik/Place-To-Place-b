//
//  TabView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 18.08.2021.
//

import SwiftUI

struct TabViewPlace: View {
    var body: some View {
        
        
        TabView {
            PlaceList()
                .tabItem {
                    Image(systemName: "video.circle.fill")
                    Text("Video")
                }

            Text("Profile Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
    
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewPlace()
    }
}
