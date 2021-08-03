//
//  PersonCell.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Foundation
import UIKit

class PersonCell : UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.circle()
    }
}
