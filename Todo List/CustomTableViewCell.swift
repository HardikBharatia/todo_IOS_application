//
//  CustomTableViewCell.swift
//  Todo List
//
//  Created by Ajit on 23/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var priorityImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var dateOfTask: UILabel!
    @IBOutlet weak var reminderIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
