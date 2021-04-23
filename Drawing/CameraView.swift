//
//  CameraView.swift
//  Drawing
//
//  Created by Renzo Paul Chamorro on 22/04/21.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var camera = CameraViewModel()
    var body: some View{
        CameraPreview(camera: camera)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                camera.checkPermissions()
            })
    }
}

struct CameraView_preview: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate  {
    
    @Published var session = AVCaptureSession()
    @Published var alert: Bool = false
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
            return
        case .denied:
            self.alert = true
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (acepted) in
                if acepted {
                    self.setupCamera()
                }
            }
        default:
            return
        }
    }
    
    func setupCamera() {
        do {
            session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            self.session.commitConfiguration()
        } catch {
            print("Error al configurar camara: \(error.localizedDescription)")
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraViewModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
