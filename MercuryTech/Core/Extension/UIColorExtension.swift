//
//  UIColorExtension.swift
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    static var colorMain = #colorLiteral(red: 0.07843137255, green: 0.1490196078, blue: 0.2862745098, alpha: 1)
    
    static var tabColor = #colorLiteral(red: 0.1140146628, green: 0.3221919537, blue: 0.8095403314, alpha: 1)
    
    static var mainDark = #colorLiteral(red: 0.2784313725, green: 0.3215686275, blue: 0.368627451, alpha: 1)
    static var mainBright = #colorLiteral(red: 0.5019607843, green: 0.5647058824, blue: 0.6470588235, alpha: 1)
    
    
    static var orangeBright = #colorLiteral(red: 0.9725490196, green: 0.6588235294, blue: 0.09019607843, alpha: 1)
    static var orangeDark = #colorLiteral(red: 0.9725490196, green: 0.5019607843, blue: 0.09019607843, alpha: 1)
    
    static var pinkBright = #colorLiteral(red: 0.9607843137, green: 0.3058823529, blue: 0.6352941176, alpha: 1)
    static var pinkDark = #colorLiteral(red: 1, green: 0.462745098, blue: 0.462745098, alpha: 1)
    
    static var skyBright = #colorLiteral(red: 0.09019607843, green: 0.9176470588, blue: 0.8509803922, alpha: 1)
    static var skyDark = #colorLiteral(red: 0.3764705882, green: 0.4705882353, blue: 0.9176470588, alpha: 1)
    
    static var purpleDark = #colorLiteral(red: 0.3843137255, green: 0.1529411765, blue: 0.4549019608, alpha: 1)
    static var purpleBright = #colorLiteral(red: 0.7725490196, green: 0.2, blue: 0.3921568627, alpha: 1)
    
    static var blueDark = #colorLiteral(red: 0.3568627451, green: 0.1411764706, blue: 0.4784313725, alpha: 1)
    static var blueBright = #colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1)
    
    static var greenDark = #colorLiteral(red: 0.09411764706, green: 0.3058823529, blue: 0.4078431373, alpha: 1)
    static var greenBright = #colorLiteral(red: 0.3411764706, green: 0.7921568627, blue: 0.5215686275, alpha: 1)
    
    static var blueMain = #colorLiteral(red: 0.1140146628, green: 0.3221919537, blue: 0.8095403314, alpha: 1)
    
    static var redLight = #colorLiteral(red: 0.6078431373, green: 0, blue: 0.07843137255, alpha: 1)
    static var redMain = #colorLiteral(red: 0.462745098, green: 0.1490196078, blue: 0.1803921569, alpha: 1)
    
     static var contentColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        } else {
            return  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
     static var contentBgColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            return  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}

