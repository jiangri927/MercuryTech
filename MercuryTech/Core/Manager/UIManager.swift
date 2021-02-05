//
//  UIManager.swift
//  HeartMyWorkOut
//
//  Created by OSX on 6/12/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit

class UIManager {
    static let shared = UIManager()

    func initTheme() {
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().barTintColor = UIColor.colorMain
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
            
            let tabBar = UITabBar.appearance()
            tabBar.tintColor = UIColor.white
            tabBar.barTintColor = UIColor.colorMain
            tabBar.backgroundColor = UIColor.colorMain
            tabBar.isTranslucent = false
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}


//App View
extension UIManager {
    static func showMain(animated: Bool = false) {
        self.gotoMainView(animated)
    }
    
    static func gotoMainView(_ animated: Bool = false){
        AppManager.shared.tabVC = TabBarController()
        AppManager.shared.navigation = UIManager.wrapNavigationController(controller: AppManager.shared.tabVC!)
        self.setRootViewController(controller: AppManager.shared.navigation!, animated: animated)
    }
    
    static func showLogin(animated: Bool = false) {
        if let controller = loadViewController(storyboard: "Auth") {
            self.setRootViewController(controller: controller, animated: animated)
        }
    }
    
    static func gotoBroadCast(animated: Bool = false) {
        let broadcastVC = BroadcastViewController()
        let nav = UIManager.wrapNavigationController(controller: broadcastVC)
        self.setRootViewController(controller: nav, animated: animated)
    }
}

//Safe area
extension UIManager {
    static func bottomPadding() -> CGFloat {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    static func topPadding() -> CGFloat {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    static func windowFrame(of view: UIView) -> CGRect {
        var maskRect = view.convert(view.frame, to: UIApplication.shared.keyWindow!)
        maskRect.origin.y = maskRect.origin.y + UIManager.topPadding()
        return maskRect
    }
}

//Primary
extension UIManager {
    
    static func wrapNavigationController(controller: UIViewController) -> UINavigationController {
        return BaseNavigationController(rootViewController: controller)
    }
    
    static func loadViewController(storyboard name: String, controller identifier: String? = nil) -> UIViewController? {
        guard let identifier = identifier else {
            return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
        }
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    static func modal(controller: UIViewController, parentController: UIViewController? = nil) {
        guard let presenter = parentController ?? UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        presenter.present(controller, animated: true, completion: nil)        
    }
    
    //change root view controller
    static func setRootViewController(controller: UIViewController, animated: Bool = false) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                guard let rootViewController = window.rootViewController else {
                    return
                }
                
                controller.view.frame = rootViewController.view.frame
                controller.view.layoutIfNeeded()
                
                if animated {
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = controller
                    }, completion: nil)
                }
                else {
                    window.rootViewController = controller
                }
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.backgroundColor = UIColor.white
                appDelegate.window?.rootViewController = controller
                appDelegate.window?.makeKeyAndVisible()
                UIView.transition(with: appDelegate.window!, duration: 0.1, options: .transitionCrossDissolve, animations: nil, completion: { _ in })
            }
        }
    }
}
