//
//  UIViewControllerExtension.swift
//
//  Created by OSX on 7/31/19.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import SafariServices

typealias AlertData = (title: String, message: String, buttons: [String], completion: (Int) -> Void)

extension UIViewController {
    func isRootController() -> Bool {
        let vc = self.navigationController?.viewControllers.first
        if self == vc {
            return true
        }
        return false
    }
    
    func showAlert(_ title: String, message: String? = nil, actionTitle: String = "OK", completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            completionHandler?()
        }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func showError(_ title: String, message: String? = nil, actionTitle: String = "OK", completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            completionHandler?()
        }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertToConfirm(_ title: String, message: String? = nil, actionTitle: String = "Yes", otherTitle: String = "No", completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            completionHandler?()
        }
        let cancelAction = UIAlertAction(title: otherTitle, style: .default) { (action) in
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertwithEditText(_ title: String, message: String? = nil, primaryAction:String, otherTitle:String = "Cancel", completionHandler: ((String, Bool) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Cool workout"
            textField.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        let defaultAction = UIAlertAction(title: primaryAction, style: .default) { (action) in
            guard let text = alert.textFields![0].text else { return }
            completionHandler?(text, false)
        }
        let otherAction = UIAlertAction(title: otherTitle, style: .destructive, handler: { (_) in
            completionHandler?("", true)
        })
        alert.addAction(otherAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentMailViewController() {
        if let url = URL(string: "mailto:\(Constant.Support.emailAddress)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            return
        }
    }
    
    func setClearNavigationBar() {
      navigationController?.navigationBar.isTranslucent = true
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.backgroundColor = .clear
      navigationController?.navigationBar.barTintColor = .clear
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func updateTitleView(title: String, subtitle: String?, baseColor: UIColor = .white) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = baseColor
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = baseColor.withAlphaComponent(0.95)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
    }
}

extension UIAlertController {
    
    func isValidText(_ text: String) -> Bool {
        return text != ""
    }
    
    @objc func textDidChangeInLoginAlert() {
        if let text = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isValidText(text)
        }
    }
}

extension UIViewController: SFSafariViewControllerDelegate {
    
    func presentWebViewController(_ url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }
    
    
}

public extension UIViewController {
    func add(_ child: UIViewController, to: UIView? = nil, frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        if let toView = to{
            toView.addSubview(child.view)
        }else{
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var bottomInset: CGFloat{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    var topInset: CGFloat{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return topLayoutGuide.length
        }
    }
    
}

public extension UIScrollView{
    func donotAdjustContentInset(){
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

internal extension UIView{
    func constraint(to view: UIView, attribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute,  inset: CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: secondAttribute,
                                   multiplier: 1,
                                   constant: inset)
        c.isActive = true
    }
    
    func constraint(_ anchor: NSLayoutDimension, constant: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        anchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: insets.top)
        
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: insets.bottom)
        
        let leading = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .leading,
                                        multiplier: 1,
                                        constant: insets.left)
        
        let trailing = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .trailing,
                                        multiplier: 1,
                                        constant: insets.right)
        top.isActive = true
        bottom.isActive = true
        leading.isActive = true
        trailing.isActive = true
    }
}
