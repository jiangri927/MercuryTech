//
//  ControlHelper.swift
//  HeartMyWorkOut
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit

extension UIView {
    func addChild(view: UIView) {
        if self is UIStackView {
            (self as! UIStackView).addArrangedSubview(view)
        }
        else {
            self.addSubview(view)
        }
    }
    
    func removeAllSubViews() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
    }
}

extension UILabel {
    convenience init(font: UIFont, color: UIColor, backgroundColor: UIColor = .clear, letterSpacing: CGFloat = 0, superView: UIView? = nil) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.backgroundColor = backgroundColor
        self.letterSpacing = letterSpacing
        
        superView?.addChild(view: self)
    }
}

extension UIButton {
    convenience init(image: UIImage? = nil, selectedImage: UIImage? = nil, action: Selector, target: Any, superView: UIView? = nil) {
        self.init(type: .custom)
        self.frame = .zero
        self.backgroundColor = .clear
        
        self.setImage(image, for: .normal)
        self.setImage(selectedImage, for: .selected)
        
        self.addTarget(target, action: action, for: .touchUpInside)
        
        superView?.addChild(view: self)
    }
}


extension UIImageView {
    convenience init(backgroundColor: UIColor = .clear, contentMode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit, superView: UIView? = nil) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superView?.addChild(view: self)
    }
}
