//
//  SettingsViewController.swift
//  MercuryTech
//
//  Created by 222 on 7/10/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = AppManager.shared.currentUser else { return }
        fullnameLbl.text = currentUser.fullName
        guard let username = currentUser.username else { return }
        usernameLbl.text =  "@\(username)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
