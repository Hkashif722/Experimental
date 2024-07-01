//
//  tableHeader.swift
//  Expremental
//
//  Created by Kashif Hussain on 04/04/24.
//

import UIKit

final class tableHeader: UIView {

    @IBOutlet weak var ImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "tableHeader") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
}
