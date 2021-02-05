//
//  UIFontExtension.swift
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit

extension UIFont {
    static var header: UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: .bold)
    }
    
    static var exerciseLabel: UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: .bold)
    }
    
    static var restLabel: UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }
}
