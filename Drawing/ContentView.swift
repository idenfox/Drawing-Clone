//
//  ContentView.swift
//  Drawing
//
//  Created by Renzo Paul Chamorro on 22/04/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var image: UIImage?
    @State var shouldShowImagePIcker: Bool = false
     
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    shouldShowImagePIcker = true
                }, label: {
                    Text("Elige foto")
                })
                NavigationLink(
                    destination: SecondView(image: $image),
                    label: {
                        Text("Entrar")
                    })
                    .padding()
                    .navigationTitle("Drawing")
            }
        }.sheet(isPresented: $shouldShowImagePIcker, content: {
            ImagePicker(image: $image, isShown: $shouldShowImagePIcker)
        })
    }

}

struct SecondView: View {
    
    @Binding var image: UIImage?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView()
            Image(uiImage: image ?? UIImage(named: "placeholder")!)
                .resizable()
                .scaledToFill()
                .rotationEffect(.degrees(-90))
                .opacity(0.25)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool

    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator

    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isShown: $isShown)
    }

}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>) {
        self._image = image
        self._isShown = isShown
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = uiImage
            self.isShown = false
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



