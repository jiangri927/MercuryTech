//
//  UserCell.swift
//  FitShare
//
//  Created by 222 on 6/20/20.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    var user:User!
    
    static var reuseIdentifier: String {
        return String(describing: UserCell.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
