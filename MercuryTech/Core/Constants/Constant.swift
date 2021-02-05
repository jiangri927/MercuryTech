//
//  Constant.swift
//  HeartMyWorkOut
//
//  Created by 222 on 1/9/20.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit

struct Constant {
    struct UI {
        static let TAP_BAR_HEIGHT: CGFloat = 60
        static let COMMON_BUTTON_HEIGHT = 40
        static var SCREEN_WIDTH: CGFloat {
            return UIScreen.main.bounds.width
        }
        
        static let ROW_HEIGHT: CGFloat = 40
    }
    
    struct URLs {
        static let termsConditions = "https://mercury.us/terms.html"
    }
    
    struct Support {
        static let emailAddress = "info@mercury.us"
        static let subject = "Support"
    }
}

struct Keys {
    static let bfApiKey = "ebeb2a03-e836-4930-9bc0-bce5472f72e0"
}

struct UserKeys {
    static let userID = "userID"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let username = "username"
}

struct MessageKeys {
    static let messageID = "messageID"
    static let sender = "sender"
    static let receiver = "receiver"
    static let text = "text"
    static let received = "received"
    static let mesh = "mesh"
    static let date = "date"
    static let deviceType = "deviceType"
    static let broadcast = "broadcast"
}
