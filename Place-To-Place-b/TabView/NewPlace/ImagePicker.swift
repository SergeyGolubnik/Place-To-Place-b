//
//  ImagePicker.swift
//  Place-To-Place-b
//
//  Created by СОВА on 06.12.2021.
//

import SwiftUI
import Photos
import Firebase
import SDWebImageSwiftUI



struct ImagePicker : View {
    @State var image = UIImage(named: "avatar-1")
    @Binding var gelleryStringArray: [String]
    @State var show = false
    @State var showImagePicker = false
    @State var showSheet = false
    @State var isLoading = false
    @State var defaultImage = UIImage(named: "fon-1")
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View{
        
        ZStack{
            
            
            VStack{
                
                
                if !self.gelleryStringArray.isEmpty{
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 20){
                            
                            ForEach(self.gelleryStringArray,id: \.self){i in
                                ZStack{
                                    VStack{
                                        
                                    
//                                    Image(uiImage: i)
                                    WebImage(url: URL(string: i))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .cornerRadius(15)
                                    }
                                       
                                    if gelleryStringArray.count > 1 {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Image(systemName: "trash.circle.fill")
                                                    .background(Color.white)
                                                    .font(Font.system(size: 30))
                                                    .cornerRadius(25)
                                                    .padding()
                                                
                                                Spacer()
                                            }
                                            
                                        }.onTapGesture {
                                            let index = gelleryStringArray.firstIndex(of: i)
                                            let desertRef = Storage.storage().reference().child(gelleryStringArray[index!])

                                            // Delete the file
                                            desertRef.delete { error in
                                              if let error = error {
                                                  print("Tap gesture delete\(error.localizedDescription)")
                                              }
                                            }
                                            
                                            if gelleryStringArray.count > 0 {
                                            
                                                gelleryStringArray.remove(at: index!)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Button(action: {
                    self.showSheet.toggle()
                    print(gelleryStringArray)
                    isLoading = true
                }) {
                    if gelleryStringArray.count <= 9 {
                        Text(gelleryStringArray == [] ? "Добавить фото" : "Добавьте еще фото")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                        
                    }
                    
                }.overlay (
                    ZStack {
                        if isLoading {
                            Color.black
                                .opacity(0.25)
                            
                            ProgressView()
                                .font(.title2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(12)
                        }
                    })
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.top, 25)
                .sheet(isPresented: $showImagePicker, content: {
                    OpenGallary(isShown: $showImagePicker, image: $image, imageBol: .constant(false), sourceType: sourceType)
                })
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Загрузите фото"), message: nil, buttons: [
                        .default(Text("Галерея")) {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text("Камера")) {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        },
                        .cancel(Text("Выход"))
                    ])
                }
            }
            
        }.onChange(of: image) { _ in
            let imageName = "place-to-lace\(UUID().uuidString)\(String(Date().timeIntervalSince1970))"
            FirebaseAuthDatabase.aploadImage(photoName: imageName, photo: image!, dataUrl: "gellery") { (result) in
                switch result {
                    
                case .success(let url):
                    gelleryStringArray.append(url.absoluteString)
                    isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(gelleryStringArray: .constant([""]))
    }
}
