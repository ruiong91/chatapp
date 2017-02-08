//
//  Channel.swift
//  NextChat
//
//  Created by Rui Ong on 03/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation

class Channel {
    var name: String?
    var id : String?
    var chats: [Chat] = []
    
    init(withDictionary dictionary: [String : Any], index: Int) {
        
        id = String(index)
        name = dictionary["name"] as? String
        
        if let allChats = dictionary["chats"] as? [Any] {
            for aChat in allChats {
                if let ChatValue = aChat as? [String:Any] {
                    let newChat = Chat(withDictionary: ChatValue)
                    chats.append(newChat)
                }
            }
        }
    }
    
    func membersName() -> String {
        var members : String = ""
        
        var _membersName : Set<String> = Set()
        
        for chat in chats{
            if let name = chat.senderName {
                _membersName.insert(name)
            }
        }
        
        for _member in _membersName {
            members.append(_member)
        }
        
        return members
    }
}
