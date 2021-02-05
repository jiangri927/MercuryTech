//
//  LoginViewController.swift
//  MercuryTech
//
//  Created by 222 on 7/14/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var fullNameTextFild: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onStart(_ sender: Any) {
        guard let name = fullNameTextFild.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        DataController.shared.insertUser(withText: name, username: username) { user in
            if let user = user {
                let dic = [
                    UserKeys.userID: user.userID!,
                    UserKeys.firstName: user.firstName!,
                    UserKeys.lastName: user.lastName!,
                    UserKeys.username: user.username!
                    ] as [String : Any]
                BridgefyManager.shared.sendUser(dic)
            }
            UIManager.showMain(animated: true)
        }
    }
    
}
