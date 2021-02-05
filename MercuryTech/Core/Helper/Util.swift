//
//  Util.swift
//  HeartMyWorkOut
//
//  Created by joseph on 9/4/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import Foundation

internal final class Util {
    static let shared = Util()
    private init() { }
    
    func generateBucketKey() -> String? {
        var userID: String
        if let currentUserID = AppManager.shared.currentUser?.userID, currentUserID.count > 0  {
            userID = currentUserID
        } else {
            // User might not be logged in
            userID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        }
        let jpegExtension = ".jpg"
        let placeDirectory = "photos"
        let uuidString = UUID().uuidString
        // guard let uuidString = UUID().uuidString.replacingCharacters(in: "-", with: "")
        return "\(placeDirectory)_\(userID)_\(uuidString)\(jpegExtension)"
    }
    
    func shareImageBucketKey() -> String? {
        let currentTimeStr: String = String(format: "%d", (Int)(Date().timeIntervalSince1970))
        let jpegExtension = ".jpg"
        let placeDirectory = "photos"
        // guard let uuidString = UUID().uuidString.replacingCharacters(in: "-", with: "")
        return "\(placeDirectory)_\(currentTimeStr)\(jpegExtension)"
    }
    
}
