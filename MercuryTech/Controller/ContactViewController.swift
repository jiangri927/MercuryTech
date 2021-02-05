//
//  ContactViewController.swift
//  MercuryTech
//
//  Created by 222 on 6/26/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var noContactsLbl: UILabel!
    
    var users:[User] = []
    var colorArray:[UIColor] = [.redLight, .redMain, .blueMain, .greenBright, .greenDark, .blueBright, .greenDark, .blueBright, .blueDark, .purpleBright, .purpleDark, .skyDark, .skyBright, .pinkDark, .pinkBright, .orangeDark, .orangeBright, .mainBright, .mainDark, .tabColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsers()
    }
    
    private func setupUI(){
        noContactsLbl.isHidden = true
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.register(UserCell.nib, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    func setNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(didReceive), name: .didReceivedUser, object: nil)
    }
    
    @objc  func didReceive() {
        loadUsers()
    }
    
    private func loadUsers(){
        self.users = DataController.shared.getAllUsers()
        noContactsLbl.isHidden = self.users.count != 0
        self.contactTableView.reloadData()
    }
    
    func gotoChatVC(_ user:User){
        let destinationVC = ChatViewController()
        destinationVC.otherUser = user
        let nav = UIManager.wrapNavigationController(controller: destinationVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.profileImageview.backgroundColor = colorArray[Int.random(in: 0...colorArray.count)]
        cell.userNameLbl.textColor = .contentColor
        cell.userNameLbl.text = user.fullName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoChatVC(users[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
