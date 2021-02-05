//
//  User+CoreDataProperties.swift
//  MercuryTech
//
//  Created by 222 on 7/13/20.
//  Copyright © 2020 222. All rights reserved.
//
//

import Foundation
import CoreData


extension User {
    var fullName: String? {
        get {
            var name: String = ""
            if let firstName = self.firstName {
                name += firstName
            }
            if let lastName = self.lastName {
                name += " \(lastName)"
            }
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        set {
            guard let newValue = newValue else { return }
            let names = newValue.components(separatedBy: " ")
            var firstName: String?
            var lastName: String?
            if names.count >= 2 {
                firstName = names[0]
                lastName = names[1]
            } else if names.count == 1 {
                firstName = names[0]
            }
            self.firstName = firstName
            self.lastName = lastName
        }
    }
    
    var simpleName: String? {
        get {
            var name: String = ""
            if let firstName = self.firstName, let firstN = firstName.first {
                name += "\(firstN)"
            }
            if let lastName = self.lastName, let lastN = lastName.first {
                name += "\(lastN)"
            }
            return name
        }
    }
}
