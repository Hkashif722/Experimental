//
//  DragableResizableProtocol.swift
//  Expremental
//
//  Created by Kashif Hussain on 01/07/24.
//

import Foundation

import UIKit

class DraggableResizableHandler: NSObject {

    private weak var view: UIView?
    private var initialBounds: CGRect = .zero

    init(view: UIView) {
        self.view = view
        super.init()
        setupView()
    }

    private func setupView() {
        guard let view = view else { return }

        // Add pan gesture for dragging
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)

        // Create and add the resize handle
        let handleImage = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        let resizeHandle = UIImageView(image: handleImage)
        resizeHandle.frame = CGRect(x: view.bounds.width - 30, y: view.bounds.height - 30, width: 20, height: 20)
        resizeHandle.tintColor = .gray
        resizeHandle.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        view.addSubview(resizeHandle)

        let resizeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        resizeHandle.addGestureRecognizer(resizeGesture)
        resizeHandle.isUserInteractionEnabled = true

        // Setup view appearance
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.clipsToBounds = true
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view.superview)
        switch gesture.state {
        case .began:
            break
        case .changed:
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: view.superview)
        default:
            break
        }
    }

    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        guard let resizeHandle = gesture.view, let view = resizeHandle.superview else { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialBounds = view.bounds
        case .changed:
            var newWidth = initialBounds.width + translation.x
            var newHeight = initialBounds.height + translation.y
            
            // Apply constraints
            newWidth = max(100, min(200, newWidth))
            newHeight = max(100, min(200, newHeight))
            
            view.bounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
            
            // Update the camera preview layer frame
            if let cameraHandler = view.cameraCaptureHandler {
                cameraHandler.updatePreviewLayerFrame()
            }
        default:
            break
        }
    }
}


private var handlerKey: UInt8 = 0

extension UIView {

    var draggableResizableHandler: DraggableResizableHandler? {
        get {
            return objc_getAssociatedObject(self, &handlerKey) as? DraggableResizableHandler
        }
        set {
            objc_setAssociatedObject(self, &handlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func makeDraggableResizable() {
        draggableResizableHandler = DraggableResizableHandler(view: self)
    }
}



//MARK: -  Camera Capture

import UIKit
import AVFoundation

enum CaptureMode {
    case photo
    case video
}

class CameraCaptureHandler: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {

    private weak var view: UIView?
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    var captureMode: CaptureMode = .photo
    private var completion: ((UIImage?, URL?) -> Void)?

    init(view: UIView) {
        self.view = view
        super.init()
        setupSession()
    }

    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let captureDevice = getFrontCamera() else {
            print("Failed to get the front camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)

            if captureMode == .photo {
                photoOutput = AVCapturePhotoOutput()
                if let photoOutput = photoOutput {
                    captureSession?.addOutput(photoOutput)
                }
            } else {
                videoOutput = AVCaptureMovieFileOutput()
                if let videoOutput = videoOutput {
                    captureSession?.addOutput(videoOutput)
                }
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = .resizeAspectFill
            if let previewLayer = previewLayer {
                view?.layer.addSublayer(previewLayer)
                previewLayer.frame = view?.bounds ?? .zero
            }
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        } catch {
            print(error)
            return
        }
    }
    
    func updatePreviewLayerFrame() {
        previewLayer?.frame = view?.bounds ?? .zero
    }
    
    private func getFrontCamera() -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        return discoverySession.devices.first
    }
    

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        self.completion = { image, _ in
            completion(image)
        }
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    func captureVideo(completion: @escaping (URL?) -> Void) {
        self.completion = { _, url in
            completion(url)
        }
        let outputPath = NSTemporaryDirectory() + "output.mov"
        let outputFileURL = URL(fileURLWithPath: outputPath)
        videoOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
    }

    func stopVideoRecording() {
        videoOutput?.stopRecording()
    }

    // MARK: - AVCapturePhotoCaptureDelegate

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        completion?(image, nil)
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        completion?(nil, outputFileURL)
    }
}

private extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let nextResponder = parentResponder?.next {
            parentResponder = nextResponder
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

private var cameraHandlerKey: UInt8 = 0

extension UIView {

    var cameraCaptureHandler: CameraCaptureHandler? {
        get {
            return objc_getAssociatedObject(self, &cameraHandlerKey) as? CameraCaptureHandler
        }
        set {
            objc_setAssociatedObject(self, &cameraHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func enableCameraCapture(captureMode: CaptureMode) {
        cameraCaptureHandler = CameraCaptureHandler(view: self)
        cameraCaptureHandler?.captureMode = captureMode
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        cameraCaptureHandler?.capturePhoto(completion: completion)
    }

    func captureVideo(completion: @escaping (URL?) -> Void) {
        cameraCaptureHandler?.captureVideo(completion: completion)
    }

    func stopVideoRecording() {
        cameraCaptureHandler?.stopVideoRecording()
    }
}
