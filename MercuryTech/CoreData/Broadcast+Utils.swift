//
//  Broadcast+CoreDataProperties.swift
//  MercuryTech
//
//  Created by 222 on 7/13/20.
//  Copyright © 2020 222. All rights reserved.
//
//

import Foundation
import CoreData

extension Broadcast {
    
    var d_Type: DeviceType {
        get {
            return DeviceType(rawValue: Int(self.deviceType))!
        }
        set {
            self.deviceType = Int16(newValue.rawValue)
        }
    }
    
    var date: Date {
        get {
            return Date(timeIntervalSince1970: self.time)
        }
        set {
            self.time = newValue.timeIntervalSince1970
        }
    }
    
    var textDate: String {
        return self.date.timeAgoString(numericDates: true)
    }
}

