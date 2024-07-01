//
//  PopupView.swift
//  Expremental
//
//  Created by Kashif Hussain on 29/06/24.
//

import Foundation
import UIKit
import UIKit

class PopupViewController: UIViewController {
    
    var buttonPressed: (() -> Void)?
    
//    lazy var blurEffectView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        return blurEffectView
//    }()
    
    lazy var popupView: PopupView = {
        let view = PopupView()
        view.submitBtnPressend = { [weak self]  in
            self?.buttonPressed?()
            self?.dismiss(animated: true, completion: nil)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white.withAlphaComponent(0.3)
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 15.0
//        setupBlurEffect()
        setupPopupView()
    }
    
//    private func setupBlurEffect() {
//        view.addSubview(blurEffectView)
//        NSLayoutConstraint.activate([
//            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
//            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
    
    private func setupPopupView() {
        view.addSubview(popupView)
        
        NSLayoutConstraint.activate([
            popupView.leadingToSuperview(),
            popupView.trailingToSuperview(),
            popupView.topToSuperview(),
            popupView.bottomToSuperview()
        ])
       
    }
}

import SwiftUI

@available(iOS 13.0.0, *)
struct OTTVC_Preview1: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            PopupViewController()
        }
    }
}




class PopupView: UIView {
    
    var submitBtnPressend: (() -> ())?
    
    lazy var titleHeader: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.text = "Terms of Services"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var subTitleHeader: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .italicSystemFont(ofSize: 12)
        lbl.text = "last update to january 2018"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    lazy var headerStack: UIStackView = {
        let vStk = UIStackView(arrangedSubviews: [titleHeader,subTitleHeader])
        vStk.distribution = .fill
        vStk.alignment = .fill
        vStk.axis = .vertical
        vStk.translatesAutoresizingMaskIntoConstraints = false
        return vStk
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(headerStack)
        print("check")
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.leadingToSuperview(offset: 20),
            headerStack.trailingToSuperview(offset: -20),
            headerStack.topToSuperview(offset: 20),
            headerStack.bottomToSuperview(offset: -20)
            
        ])
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var termsAndCondTextField: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .green
//        textField.placeholder = "Terms And Condition"
        let txt = 
        """
        Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
        """
        textField.text = txt
        textField.textColor = .gray
        textField.font = .preferredFont(forTextStyle: .caption1)
//        textField.borderStyle = .roundedRect
        textField.isEditable = false
        return textField
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsAndCondTextField)
        
        NSLayoutConstraint.activate([
            termsAndCondTextField.leadingToSuperview(),
            termsAndCondTextField.trailingToSuperview(),
            termsAndCondTextField.topToSuperview(),
            termsAndCondTextField.bottomToSuperview()
        ])
        return view
    }()
    
    lazy var contanerHStack: UIStackView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        let spacer1 = UIView()
        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer1.widthAnchor.constraint(equalToConstant: 5).isActive = true
        let vStk = UIStackView(arrangedSubviews: [ spacer,contentView,spacer1])
        vStk.distribution = .fill
        vStk.alignment = .fill
        vStk.spacing = 10
        vStk.axis = .horizontal
        return vStk
    }()
    
    lazy var Submitbutton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Subnmit", for: .normal)
        btn.addTarget(self, action: #selector(didSelecSubmitBtn), for: .touchUpInside)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    lazy var btnHStack: UIStackView = {
        let vStk = UIStackView(arrangedSubviews: [UIView(), Submitbutton, UIView()])
        vStk.distribution = .equalCentering
        vStk.alignment = .fill
        vStk.spacing = 10
        vStk.axis = .horizontal
        return vStk
    }()
    
    lazy var parentVStak: UIStackView = {
        let vStk = UIStackView(arrangedSubviews: [headerView, divider, contanerHStack,btnHStack])
        vStk.distribution = .fill
        vStk.alignment = .fill
        vStk.spacing = 10
        vStk.axis = .vertical
        return vStk
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        self.addSubview(parentVStak)
        NSLayoutConstraint.activate([
            parentVStak.centerXToSuperview(),
            parentVStak.centerYToSuperview(),
            parentVStak.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            parentVStak.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            parentVStak.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            parentVStak.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func didSelecSubmitBtn() {
//        self.backgroundColorInput?(self.dataTextField.text ?? "")
        self.submitBtnPressend?()
    }
}


class CustomPresentationController: UIPresentationController {
    
    private var blurEffectView: UIVisualEffectView!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(blurEffectView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        
        let size = CGSize(width: containerView.bounds.width - 50, height: containerView.bounds.height - 150)
        let origin = CGPoint(x: (containerView.bounds.width - size.width) / 2,
                             y: (containerView.bounds.height - size.height) / 2)
        return CGRect(origin: origin, size: size)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}


class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(isPresenting: false)
    }
}


class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if isPresenting {
            guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            toViewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           usingSpringWithDamping: 0.5, // Adjust damping for bounce effect
                           initialSpringVelocity: 0.5,  // Adjust velocity for bounce effect
                           options: .curveEaseInOut,
                           animations: {
                toViewController.view.alpha = 1
                toViewController.view.transform = CGAffineTransform.identity
            }) { finished in
                transitionContext.completeTransition(finished)
            }
        }  else {
            guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromViewController.view.alpha = 0
                fromViewController.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { finished in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
}

