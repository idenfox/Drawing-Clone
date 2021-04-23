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
                ZStack {
                    Image("background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Circle()
                            .fill(Color(#colorLiteral(red: 0.968627451, green: 0.8196078431, blue: 0.768627451, alpha: 1)))
                            .opacity(0.8)
                            .frame(width: 200, height: 200)
                            .background(Color.clear)
                            .overlay(
                                VStack {
                                    Image("main_icon")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .offset(y: 30)
                                    Text("Drawy")
                                        .foregroundColor(Color(#colorLiteral(red: 0.04638890177, green: 0.2549735308, blue: 0.2528440356, alpha: 1)))
                                        .font(Font.custom("Pacifico-Regular", size: 40))
                                        .offset(y: -20)
                                }
                            )
                            .padding()
                        Spacer()
                        Button(action: {
                            shouldShowImagePIcker = true
                        }, label: {
                            HStack {
                                Text("1")
                                    .foregroundColor(.white)
                                    .font(Font.custom("Pacifico-Regular", size: 140))
                                    .padding(.horizontal)
                                Spacer()
                                Text("Selecciona la imagen que quieres dibujar!")
                                    .foregroundColor(.white)
                                    .font(Font.custom("Pacifico-Regular", size: 30))
                                    .padding()
                                
                            }
                        })
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .background(Color(#colorLiteral(red: 0.968627451, green: 0.8196078431, blue: 0.768627451, alpha: 1)))
                        NavigationLink(
                            destination: SecondView(image: $image)
                                .edgesIgnoringSafeArea(.all),
                            label: {
                                HStack {
                                    Text("Comienza a Dibujar!")
                                        .foregroundColor(Color(#colorLiteral(red: 0.968627451, green: 0.8196078431, blue: 0.768627451, alpha: 1)))
                                        .font(Font.custom("Pacifico-Regular", size: 30))
                                        .padding()
//                                    Spacer()
                                    Text("2")
                                        .foregroundColor(Color(#colorLiteral(red: 0.968627451, green: 0.8196078431, blue: 0.768627451, alpha: 1)))
                                        .font(Font.custom("Pacifico-Regular", size: 140))
                                        .padding(.horizontal)
                                        .offset(y: -20)
                                    
                                }
                            })
                            .frame(width: UIScreen.main.bounds.width, height: 200)
                            .background(Color(#colorLiteral(red: 0.04638890177, green: 0.2549735308, blue: 0.2528440356, alpha: 1)))
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }.sheet(isPresented: $shouldShowImagePIcker, content: {
                ImagePicker(image: $image, isShown: $shouldShowImagePIcker)
        })
        }
    }
    

struct SecondView: View {
    
    @Binding var image: UIImage?
    @State var sliderValue: Double = 5
    @State private var isEditing = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView()
            VStack{
                Image(uiImage: image ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .rotationEffect(.degrees(-90))
                    .aspectRatio(contentMode: .fit)
                    .opacity(sliderValue/10)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
                Slider(
                    value: $sliderValue,
                    in: 0...10,
                    step: 0.5,
                    onEditingChanged: { editing in
                        isEditing = editing
                    },
                    minimumValueLabel: Text("0"),
                    maximumValueLabel: Text("10")
                ) {
                    Text("Speed")
                }
            }
            .edgesIgnoringSafeArea(.all)
            .padding()
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
        Group {
            ContentView()
        }
    }
}



