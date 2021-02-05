//
//  TabBarViewController.swift
//  BetIT
//
//  Created by OSX on 7/31/19.
//  Copyright © 2019 MajestykApps. All rights reserved.
//

import UIKit

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + Constant.UI.TAP_BAR_HEIGHT
        return sizeThatFits
    }
}

class TabBarController: UITabBarController {
    
    static var shared:TabBarController?
    private var btnCreate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.shared = self
        buildControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppManager.shared.navigation?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var newFrame = tabBar.frame
        newFrame.size.height = Constant.UI.TAP_BAR_HEIGHT + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
        newFrame.origin.y = view.frame.size.height - newFrame.size.height
        
        tabBar.frame = newFrame
        if let btnCreate = btnCreate {
            self.view.bringSubviewToFront(btnCreate)
        }
        
    }
    
    func buildControllers() {
        let controllerAssets: [(icon: String, title: String, storyboardId: String, horzOffset: Int)] = [
            (icon: "chat_icon", title: "Chats", storyboardId: "Chat", horzOffset: 0),
            (icon: "group_icon", title: "Broadcast", storyboardId: "Broadcast", horzOffset: 0),
            (icon: "settings_icon", title: "Settings", storyboardId: "Settings", horzOffset: 0)
        ]
        
        var childControllers: [UIViewController] = []
        for i in 0..<controllerAssets.count {
            let asset = controllerAssets[i]
            if let navigationController = UIManager.loadViewController(storyboard: asset.storyboardId) {
                let image = UIImage(named: asset.icon)
                let tabBarItem = UITabBarItem(title: asset.title, image: image?.withRenderingMode(.alwaysTemplate), tag: i)
                tabBarItem.selectedImage = image?.withRenderingMode(.alwaysTemplate)
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: CGFloat(asset.horzOffset), vertical: 0)
                
                navigationController.tabBarItem = tabBarItem
                childControllers.append(navigationController)
            }
        }
        self.viewControllers = childControllers
    }
    
}

