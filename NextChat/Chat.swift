//
//  Chats.swift
//  NextChat
//
//  Created by Rui Ong on 03/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit

class Chat{
    var senderID : String?
    var senderName : String?
    var text : String?
    var image : URL?
    var timeStamp : TimeInterval?
    
    var realImage: UIImage?
    
    init(withDictionary dictionary: [String : Any]) {
        
        senderID = dictionary["senderID"] as? String
        senderName = dictionary["senderName"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? TimeInterval
        if let imageURL = dictionary["image"] as? String {
            image = URL(string: imageURL)
        }
        
        
    }
    
    //extracting and converting time interval to Date String
    func timeAgo() -> String {
        guard let timestamp = timeStamp
            else {return ("unknown")}
        
        let sentTIme = Date(timeIntervalSinceReferenceDate: timestamp)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "d MMM yyyy HH:mm:ss"
        
        return dateformatter.string(from: sentTIme)
    }
}
