//
//  NotificationExtension.swift
//  HeartMyWorkOut
//
//  Created by joseph on 8/25/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didFailConnectingToUser = Notification.Name("didFailConnectingToUser")
    static let didSendDirectPacket = Notification.Name("didSendDirectPacket")
    static let didFailForPacket = Notification.Name("didFailForPacket")
    static let didDetectNearbyUser = Notification.Name("didDetectNearbyUser")
    static let userIsNotAvailable = Notification.Name("userIsNotAvailable")
    static let didDetectConnectionWithUser = Notification.Name("didDetectConnectionWithUser")
    static let didDetectDisconnectionWithUser = Notification.Name("didDetectDisconnectionWithUser")
    static let didFailAtStartWithError = Notification.Name("didFailAtStartWithError")
    
    static let didReceiveBroadcast = Notification.Name("didReceiveBroadcast")
    static let didReceiveMessage = Notification.Name("didReceiveMessage")
    static let didReceivedUser = Notification.Name("didReceivedUser")
}
