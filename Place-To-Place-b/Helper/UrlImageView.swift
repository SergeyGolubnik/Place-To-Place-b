//
//  UrlImageView.swift
//  Place-To-Place-b
//
//  Created by СОВА on 25.09.2021.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    @State var wight: CGFloat
    @State var height: CGFloat
    @State var defaultImage: UIImage
    
    init(urlString: String?, wight: CGFloat, height: CGFloat, defaultImage: UIImage) {
        urlImageModel = UrlImageModel(urlString: urlString)
        self.wight = wight
        self.height = height
        self.defaultImage = defaultImage
    }
    
    var body: some View {
        Image(uiImage: (urlImageModel.image ?? defaultImage)!)
            .resizable()
            .scaledToFill()
            .frame(width: wight, height: height)
            .clipped()
    }
    
    static var defaultImage = UIImage(named: "place-to-place-banner")
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        if urlString != "" {
            let url = URL(string: urlString)!
            let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
            task.resume()
        }
        
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.image = loadedImage
        }
    }
}
