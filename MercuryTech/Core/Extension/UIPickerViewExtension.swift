//
//  UIPickerViewExtension.swift
//  HeartMyWorkOut
//
//  Created by 222 on 2/17/20.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import Foundation

extension UIPickerView {
   
    func setPickerLabels(labels: [String], width: CGFloat, containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
//        let midWidth:CGFloat = containedView.bounds.width / 2
//        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = (containedView.bounds.width - width * CGFloat(self.numberOfComponents))/2
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...labels.count-1 {
            let labelStr = labels[i]
            let label = UILabel.init()
            label.text = labelStr
            
            label.frame = CGRect(x: x + width * CGFloat(i), y: y, width: width, height: fontSize)
            label.font = UIFont.boldSystemFont(ofSize: fontSize)
            label.backgroundColor = .clear
            label.textColor = .redMain
            label.textAlignment = NSTextAlignment.center
            
            self.addSubview(label)
        }
    }
}
