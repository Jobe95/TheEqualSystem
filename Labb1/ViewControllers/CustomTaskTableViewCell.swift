//
//  CustomTaskTableViewCell.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-13.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class CustomTaskTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
