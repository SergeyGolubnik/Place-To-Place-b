//
//  PresentImage.swift
//  Place-To-Place-b
//
//  Created by СОВА on 16.12.2021.
//

import SwiftUI

struct PresentImage: View {
    @Binding var image: UIImage
    @State var shareBool = false
    @Binding var item: [Any]
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.black.ignoresSafeArea()
                VStack{
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 12, alignment: .center)
                        .padding(.top)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 500)
                        .clipped()
                        .padding(.top, 30)
                    Spacer()
                    Button {
                        item.removeAll()
                        item.append(image as Any)
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
        .sheet(isPresented: $shareBool) {
            ShareSheet(item: $item)
        }
        
    }
}

struct PresentImage_Previews: PreviewProvider {
    static var previews: some View {
        let image = UIImage(named: "no_image")!
        let item = [Any]()
        PresentImage(image: .constant(image), item: .constant(item))
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
