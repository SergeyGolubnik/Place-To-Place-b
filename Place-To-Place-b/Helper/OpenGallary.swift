//
//  OpenGallary.swift
//  Place-To-Place-b
//
//  Created by СОВА on 30.08.2021.
//

import SwiftUI

struct OpenGallary: UIViewControllerRepresentable {

    let isShown: Binding<Bool>
    let image: Binding<UIImage?>
    let imageBol: Binding<Bool>
    var sourceType: UIImagePickerController.SourceType = .camera

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let isShown: Binding<Bool>
        let image: Binding<UIImage?>
        let imageBol: Binding<Bool>

        init(isShown: Binding<Bool>, image: Binding<UIImage?>, imageBool: Binding<Bool>) {
            self.isShown = isShown
            self.image = image
            self.imageBol = imageBool
        }
        

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[.originalImage] as! UIImage
            
            self.image.wrappedValue = uiImage
            self.isShown.wrappedValue = false
            self.imageBol.wrappedValue = true
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown.wrappedValue = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: isShown, image: image, imageBool: imageBol)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<OpenGallary>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<OpenGallary>) {

    }
}
