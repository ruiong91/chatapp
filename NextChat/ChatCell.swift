//
//  ChatTableViewCell.swift
//  NextChat
//
//  Created by Rui Ong on 03/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var chatCell: UIView!
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
   
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    static let cellIdentifier = "ChatCell"
    static let cellNib = UINib(nibName: "ChatCell", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
