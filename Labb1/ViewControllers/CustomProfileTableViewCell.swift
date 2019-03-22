//
//  CustomProfileTableViewCell.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-15.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class CustomProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmaillabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
