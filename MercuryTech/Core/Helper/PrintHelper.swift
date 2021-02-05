//
//  PrintHelper.swift
//  HeartMyWorkOut
//
//  Created by joseph on 10/18/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import Foundation

func print(object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}
