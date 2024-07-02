//
//  DragableViewVC.swift
//  Expremental
//
//  Created by Kashif Hussain on 01/07/24.
//

import Foundation

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        enableCameraCapture(captureMode: .photo)
        makeDraggableResizable()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        enableCameraCapture(captureMode: .photo)
        makeDraggableResizable()
    }

    func triggerPhotoCapture() {
        capturePhoto { image in
            guard let image = image else { return }
            // Handle captured photo
            print("Photo captured: \(image)")
        }
    }

    func triggerVideoCapture() {
        captureVideo { videoURL in
            guard let videoURL = videoURL else { return }
            // Handle captured video
            print("Video captured: \(videoURL)")
        }
    }
}
// Usage example in a view controller
class ViewController111: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let customViewWidth: CGFloat = 150
        let customViewHeight: CGFloat = 150
        let customViewX = self.view.bounds.width - customViewWidth - 50 // 50 points padding from the right
        let customViewY: CGFloat = 50 // 50 points from the top
        
        let customView = CustomView(frame: CGRect(x: customViewX, y: customViewY, width: customViewWidth, height: customViewHeight))
        self.view.addSubview(customView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            customView.triggerPhotoCapture()
        }
    }
}


import SwiftUI

@available(iOS 13.0.0, *)
struct OTTVC_Preview2: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ViewController111()
        }
    }
}
