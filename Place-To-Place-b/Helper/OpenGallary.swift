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
    var sourceType: UIImagePickerController.SourceType = .camera

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let isShown: Binding<Bool>
        let image: Binding<UIImage?>

        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            self.isShown = isShown
            self.image = image
        }
        

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[.originalImage] as! UIImage
            
            self.image.wrappedValue = uiImage
            self.isShown.wrappedValue = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown.wrappedValue = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: isShown, image: image)
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
