//
//  CardViewController.swift
//  Expremental
//
//  Created by Kashif Hussain on 29/06/24.
//

import UIKit

class CardViewController: UIViewController {
    
//    lazy var popupView: PopupViewController = {
//        let view = PopupView()
//        view.backgroundColorInput = { colorString in
//            print("Recieved color string: \(colorString)")
//            if colorString.lowercased() == "blue" {
//                self.view.backgroundColor = .blue
//            } else {
//                self.view.backgroundColor = .purple
//            }
//            view.isHidden = true
//        }
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isHidden = true
//        return view
//    }()
    
    let customTransitionDelegate = CustomTransitionDelegate()
    
    
    lazy var cardView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var wraperView: UIView = {
        let view  = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "img1")
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        
        self.view.addSubview(wraperView)
        self.view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            wraperView.heightAnchor.constraint(equalToConstant: 200),
            wraperView.widthAnchor.constraint(equalToConstant: 200),
            wraperView.centerXToSuperview(),
            wraperView.centerYToSuperview()
        ])
        
        self.wraperView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.leadingToSuperview(),
            cardView.trailingToSuperview(),
            cardView.topToSuperview(),
            cardView.bottomToSuperview()
        ])
        
        self.cardView.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.leadingToSuperview(),
            imgView.trailingToSuperview(),
            imgView.topToSuperview(),
            imgView.bottomToSuperview()
        ])
        
        // Set up constraints for popupView
        
        // Do any additional setup after loading the view.
    }
    
    @objc func cardViewTapped() {
        // Bounce effect animation 
        presentPopupViewController()
    }
    
    func presentPopupViewController() {
        let popupVC = PopupViewController()
        popupVC.modalPresentationStyle = .custom
        popupVC.transitioningDelegate = customTransitionDelegate
        popupVC.buttonPressed =  {[weak self]  in
            print("Button Pressed.")
            // Handle the color input here if needed
        }
        self.present(popupVC, animated: true, completion: nil)
    }

}


import SwiftUI

@available(iOS 13.0.0, *)
struct OTTVC_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            CardViewController()
        }
    }
}



