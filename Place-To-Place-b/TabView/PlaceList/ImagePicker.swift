//
//  ImagePicker.swift
//  Place-To-Place-b
//
//  Created by СОВА on 06.12.2021.
//

import SwiftUI
import Photos


struct ImagePicker : View {
    @Binding var imageArray: [UIImage]
    @State var selected : [SelectedImages] = []
    @State var show = false
    
    var body: some View{
        
        ZStack{
            
            
            VStack{
                
                
                if !self.selected.isEmpty{
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 20){
                            
                            ForEach(self.selected,id: \.self){i in
                                
                                Image(uiImage: i.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Button(action: {
                    
                    self.selected.removeAll()
                    
                    self.show.toggle()
                    
                }) {
                    
                    Text(imageArray == [] ? "Добавить фото" : "Заменить фото")
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.top, 25)
            }
            .sheet(isPresented: $show) {
                CustomPicker(selected: self.$selected, imageArray: $imageArray)
            }
        }
    }
}


struct CustomPicker : View {
    
    @Binding var selected : [SelectedImages]
    @Binding var imageArray : [UIImage]
    @State var grid : [[Images]] = []
    @Environment(\.presentationMode) var presentationMode
    @State var disabled = false
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                
                if !self.grid.isEmpty{
                    ZStack{
                        
                        VStack{
                            
                            Text("Выберете не более 10 фото")
                                .fontWeight(.bold)
                            
//                            Spacer()
                        
                        .padding(.leading)
                        .padding(.top)
                        
                        ScrollView(.vertical) {
                            
                            VStack(spacing: 20){
                                
                                ForEach(self.grid,id: \.self){i in
                                    
                                    HStack{
                                        
                                        ForEach(i,id: \.self){j in
                                            
                                            Card(data: j, selected: self.$selected, imageArray: $imageArray)
                                            
                                        }
                                    }
                                }
                            }
//                            .padding(.bottom)
                        }
                        }
                        VStack{
                            
                            Button(action: {
                                
                                self.presentationMode.wrappedValue.dismiss()
                                print(imageArray.count)
                            }) {
                                
                                Text("Добавить")
                                    .foregroundColor(.white)
                                    .padding(.vertical,10)
                                    .frame(width: UIScreen.main.bounds.width / 2)
                            }
                            
                            .background(Color.red.opacity((self.selected.count != 0) ? 1 : 0.5))
                            .clipShape(Capsule())
                            .padding(.bottom)
                            .disabled((self.selected.count != 0) ? false : true)
                        }.padding(.top, 550)
                    }
                }
                else{
                    
                    if self.disabled{
                        
                        Text("Enable Storage Access In Settings !!!")
                    }
                    if self.grid.count == 0{
                        
                        Indicator()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.white)
            .cornerRadius(12)
        }
        .onAppear {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized{
                    
                    self.getAllImages()
                    self.disabled = false
                }
                else{
                    
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){
        
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            // New Method For Generating Grid Without Refreshing....
            
            for i in stride(from: 0, to: req.count, by: 3){
                
                var iteration : [Images] = []
                
                for j in i..<i+3{
                    
                    if j < req.count{
                        
                        PHCachingImageManager.default().requestImage(for: req[j], targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: options) { (image, _) in
                            guard let image = image else {
                                return
                            }
                            
                            let data1 = Images(image: image, selected: false, asset: req[j])
                            
                            iteration.append(data1)
                            
                        }
                    }
                }
                
                self.grid.append(iteration)
            }
            
        }
    }
}

struct Card : View {
    
    @State var data : Images
    @Binding var selected : [SelectedImages]
    @Binding var imageArray : [UIImage]
    
    var body: some View{
        
        ZStack{
            
            
            Image(uiImage: self.data.image)
                .resizable()
                
            
            if self.data.selected{
                
                ZStack{
                    
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .clipped()
        .onTapGesture {
            if selected.count <= 9 {
                if !self.data.selected{
                    
                    
                    self.data.selected = true
                    
                    // Extracting Orginal Size of Image from Asset
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        
                        // You can give your own Image size by replacing .init() to CGSize....
                        
                        PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .aspectFill, options: options) { (image, _) in
                            
                            guard let image = image else {
                                return
                            }
                            
                            self.selected.append(SelectedImages(asset: self.data.asset, image: image))
                            self.imageArray.append(image)
                        }
                    }
                    
                }
                else{
                    
                    for i in 0..<self.selected.count{
                        
                        if self.selected[i].asset == self.data.asset{
                            
                            self.selected.remove(at: i)
                            self.data.selected = false
                            return
                        }
                        
                    }
                }
            }
            
            
        }
        
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView  {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
        
        
    }
}

struct Images: Hashable {
    
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct SelectedImages: Hashable{
    
    var asset : PHAsset
    var image : UIImage
}

