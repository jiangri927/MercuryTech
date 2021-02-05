//
//  UITextViewExtension.swift
//  FitShare
//
//  Created by 222 on 6/15/20.
//

import UIKit

extension UITextView {
    func resolveTags(){
        let nsText:NSString = self.text as NSString
        let lines:[String] = nsText.components(separatedBy: "\n")

        let attrs = [
            NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue", size: 13),
            NSAttributedString.Key.foregroundColor : UIColor.contentColor

        ]

        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs as [NSAttributedString.Key : Any])
        for line in lines {
            let words:[String] = line.components(separatedBy: " ")
            for word in words {
                if word.hasPrefix("#") {
                    let matchRange:NSRange = nsText.range(of: word as String)
                    var stringifiedWord:String = word as String
                    stringifiedWord = String(stringifiedWord.dropFirst())
                    attrString.addAttribute(NSAttributedString.Key.link , value: "hash:\(stringifiedWord)", range: matchRange)
                    attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.redLight , range: matchRange)
                } else if word.hasPrefix("@") {
                    let matchRange:NSRange = nsText.range(of: word as String)
                    var stringifiedWord:String = word as String
                    stringifiedWord = String(stringifiedWord.dropFirst())
                    attrString.addAttribute(NSAttributedString.Key.link , value: "friends:\(stringifiedWord)", range: matchRange)
                    attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.redLight , range: matchRange)
                } else if word.hasPrefix("http") || word.hasPrefix("Http") {
                    let matchRange:NSRange = nsText.range(of: word as String)
                    let stringifiedWord:String = word as String
                    attrString.addAttribute(NSAttributedString.Key.link , value: "\(stringifiedWord)", range: matchRange)
                    attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.redLight , range: matchRange)
                }
            }
        }
        
        self.attributedText = attrString
    }
}
