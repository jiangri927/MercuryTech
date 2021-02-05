//
//  BaseViewController.swift
//  HeartMyWorkOut
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import CoreLocation

class BaseViewController: UIViewController{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override var title: String? {
        didSet {
            lblTitle?.text = title
        }
    }
    
    // Navigation Bar
    @IBInspectable var showTopBar: Bool = false
    
    // UnWind Segue
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }

    // Controller Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        
        navigationController?.delegate = self
        configureUI()
    }
    
    func configureUI() {
        //implementation
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
    }
    
    func updateNavigationBar() {
        if let navController = self.navigationController{
            navController.interactivePopGestureRecognizer?.delegate = self
            navController.setNavigationBarHidden(!showTopBar, animated: true)
            navController.navigationBar.isTranslucent = false
            if navController.navigationBar.topItem?.title == nil {
                navController.navigationBar.topItem?.title = self.title
            }
        }
    }
}

//present or dismiss
extension BaseViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let parent = self.parent {
            parent.dismiss(animated: flag, completion: nil)
        }
        else {
            super.dismiss(animated: flag, completion: nil)
        }
    }
}

//Navigation Swiping
extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false

        }
    }
}
