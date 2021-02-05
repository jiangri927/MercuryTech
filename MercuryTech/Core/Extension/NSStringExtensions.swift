//
//  NSStringExtensions.swift
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import Foundation

extension NSString{
    func decodeBase64()->String?{
        let data = Data(base64Encoded: self as String, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    func encodeBase64()->String?{
        let data = self.data(using: String.Encoding.utf8.rawValue)
        return (data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
    }
}

extension Int {
    func convertTime()->String{
        let hours = self / 3600
        let mins = (self % 3600) / 60
        return "\(hours) Hour \(mins) Min"
    }
    func convertOnlyMinSec()->String{
        let mins = self / 60
        let seconds = self % 60
        return "\(mins < 10 ? "0\(mins)" : "\(mins)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
}
