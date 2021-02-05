//
//  AppManager.swift
//  HeartMyWorkOut
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppManager: NSObject {
    static let shared = AppManager()
    
    var tabVC:TabBarController?
    var navigation:UINavigationController?
        
    override init() {
        super.init()
        loadUser()
    }
    
    // Current User
    var currentUser : User?
    
    var loggedIn: Bool{
        guard let user = currentUser else { return false }
        guard user.userID != nil else { return false }
        return true
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToString(dic:[String:String]) -> String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dic,
            options: []) {
            return String(data: theJSONData, encoding: .ascii)
        } else {
            return nil
        }
    }

    func loadUser() {
        guard let userID = BridgefyManager.shared.transmitter?.currentUser else { return }
        if let user = DataController.shared.findUser(withId: userID) {
            self.currentUser = user
        }
    }
    
    func logoutUser() {
        currentUser = nil
    }
    
}

extension AppManager {
    func showNext(animated: Bool = false) {
        if loggedIn {
            if let user = currentUser {
                let dic = [
                    UserKeys.userID: user.userID!,
                    UserKeys.firstName: user.firstName!,
                    UserKeys.lastName: user.lastName!,
                    UserKeys.username: user.username!
                    ] as [String : Any]
                BridgefyManager.shared.sendUser(dic)
            }
            UIManager.showMain(animated: animated)
        } else {
            UIManager.showLogin(animated: animated)
        }
    }
}
