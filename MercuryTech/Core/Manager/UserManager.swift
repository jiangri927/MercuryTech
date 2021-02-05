//
//  UserManager.swift
//  MercuryTech
//
//  Created by 222 on 7/10/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    
    func getAllUsers(userID: String, completion: @escaping (_ users: [User]?) -> Void) {
        completion([])
    }
}
