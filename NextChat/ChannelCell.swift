//
//  ChannelCell.swift
//  NextChat
//
//  Created by Rui Ong on 02/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    //static means 1. no need to instantiate to access the cell 2. set only once and wont change
    static let cellIdentifier = "ChannelCell"
    static let cellNib = UINib(nibName: "ChannelCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
