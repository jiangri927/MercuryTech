//
//  FindPeopleViewController.swift
//  MercuryTech
//
//  Created by 222 on 7/13/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class FindPeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let destinationVC = BroadcastViewController()
        let nav = UIManager.wrapNavigationController(controller: destinationVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    
}
