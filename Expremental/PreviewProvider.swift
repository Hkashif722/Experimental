//
//  ReviewViewer.swift
//  Expremental
//
//  Created by Kashif Hussain on 29/06/24.
//

import Foundation

import SwiftUI
@available(iOS 13.0, *)
struct ViewControllerPreview: UIViewControllerRepresentable {
  
  var viewControllerBuilder: () -> UIViewController
  
  init(_ viewControllerBuilder: @escaping () -> UIViewController) {
      self.viewControllerBuilder = viewControllerBuilder
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
      return self.viewControllerBuilder()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
   // Nothing to do here
  }
 
}

@available(iOS 13.0, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let viewBuilder: () -> View

    init(_ viewBuilder: @escaping () -> View) {
        self.viewBuilder = viewBuilder
    }

    func makeUIView(context: Context) -> View {
        return viewBuilder()
    }

    func updateUIView(_ uiView: View, context: Context) {
        // Nothing to do here
    }
}
