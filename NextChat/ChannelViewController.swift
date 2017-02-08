//
//  ViewController.swift
//  NextChat
//
//  Created by Rui Ong on 02/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChannelViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            //register custom cell
            tableView.register(ChannelCell.cellNib,forCellReuseIdentifier: ChannelCell.cellIdentifier)
            
            //configure autolayout for height
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var channels : [Channel] = []
    var dbRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        dbRef.observe(.childAdded, with: { (snapshot) in
        //            debugPrint("Added: \(snapshot)")
        //        })
        //
        //        dbRef.observe(.childRemoved, with: { (snapshot) in
        //            debugPrint("Removed: \(snapshot)")
        //        })
        //
        //        dbRef.observe(.value, with: { (snapshot) in
        //            debugPrint("Value Changed: \(snapshot)")
        //        })
        
                
        dbRef.child("channels").observe(.value, with: { (snapshot) in
            if let snapValues = snapshot.value as? [Any] {
                var channelIndex = 0
                var tempChannel : [Channel] = []
                
                for value in snapValues {
                    if let channelDictionary = value as? [String : Any] {
                        let newChannel = Channel(withDictionary: channelDictionary, index : channelIndex)
                        channelIndex += 1
                        tempChannel.append(newChannel)
                    }
                }
                self.channels = tempChannel
                self.tableView.reloadData()
            }
        })
    }
}


extension ChannelViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.cellIdentifier, for: indexPath) as? ChannelCell else {return UITableViewCell()
        }
        
        let channel = channels[indexPath.row]
        cell.mainLabel.text = channel.name
        cell.secondaryLabel.text = channel.membersName()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatbox = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        
        
        chatbox?.currentChannel = channels[indexPath.row]
        navigationController?.pushViewController(chatbox!, animated: true)
        
    }
}


