//
//  PresentImage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 16.12.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct PresentImage: View {
    @Binding var imageUrl: String
    @State var image = UIImage(named: "place-to-place-banner")
    @State var shareBool = false
    @State var item = [Any]()
    @State var isLoading = true
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.black.ignoresSafeArea()
                VStack{
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.top)
                    WebImage(url: URL(string: imageUrl))
                        .onSuccess { image, data, cacheType in
                          
                        }
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
                        .clipped()
                    Spacer()
                    Button {
                        item.removeAll()
                        item.append(image! as Any)
                        shareBool.toggle()
                    } label: {
                        HStack{
                            Text("Поделится")
                                
                            Image(systemName: "square.and.arrow.up")
                        }
                        .font(.title)
                        .foregroundColor(.white)
                    }
                }
                
            }
        }
        .onAppear(perform: {
            
            DispatchQueue.main.async {
                downImage()
            }
            
        })
        .sheet(isPresented: $shareBool) {
            ShareSheet(item: $item)
        }
        
    }
    private func downImage(){
        guard let imageUrl = URL(string: imageUrl) else {return}
        do {
            let imageData = try Data(contentsOf: imageUrl)
            image = UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }
        isLoading = false
    }
}

struct PresentImage_Previews: PreviewProvider {
    static var previews: some View {
        PresentImage(imageUrl: .constant("image"))
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    @Binding var item: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let contriller = UIActivityViewController(activityItems: item, applicationActivities: nil)
        return contriller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
