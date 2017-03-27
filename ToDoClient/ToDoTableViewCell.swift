//
//  ToDoTableViewCell.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with title:String, description:String) {
        
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}
