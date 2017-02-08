//
//  ChatViewController.swift
//  NextChat
//
//  Created by Rui Ong on 02/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatViewController: UIViewController {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    var imageUrl : URL?
    var displayThisName : String?
    var userID : String?
    var currentChannel : Channel?
    var currentChats: [Chat] = []
    var dbRef : FIRDatabaseReference!
    
    @IBOutlet weak var msgTF: UITextField!
    
    @IBOutlet weak var imageBtn: UIButton!{
        didSet{
            imageBtn.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var chatTableView: UITableView! {
        didSet{
            chatTableView.dataSource = self
            chatTableView.delegate = self
            chatTableView.register(ChatCell.cellNib, forCellReuseIdentifier: ChatCell.cellIdentifier)
            
            chatTableView.estimatedRowHeight = 80
            chatTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var sendBtn: UIButton!{
        didSet{
            sendBtn.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        observeChat()
        
        userID = FIRAuth.auth()?.currentUser?.uid
        
        dbRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["displayName"] as? String ?? ""
            
            self.displayThisName = displayName
            dump(snapshot)
            print(displayName)
        })
        
    }
    
    func displayImagePicker(){
        let pickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            pickerController.sourceType = .photoLibrary
            
            pickerController.delegate = self
            
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    
    func sendChat(){
        guard
            let channelId = currentChannel?.id
            else {return}
        
        //catching time interval
        let timestamp = Date.timeIntervalSinceReferenceDate
        let chatIndex = currentChats.count
        
    
        
        //saving time interval to database
        var chatDictionary : [String: Any] = ["senderID" : userID, "senderName" : displayThisName, "timeStamp" : timestamp]
        
        //converting url to string
        if let urlString = imageUrl?.absoluteString {
            //saving url string to database
            chatDictionary["image"] = urlString
        }
        
        if let text = msgTF.text {
            //saving msg text to database
            chatDictionary["text"] = text
        }
        
        dbRef.child("channels").child(channelId).child("chats").child(String(chatIndex)).setValue(chatDictionary)
        
        msgTF.text = ""
    }
    
    func observeChat(){
        guard
            let channelId = currentChannel?.id
            else {return}
        dbRef.child("channels").child(channelId).child("chats").observe(.childAdded, with: { (snapshot) in
            
            //appendChat
            guard let value = snapshot.value as? [String: Any] else {return}
            let newChat = Chat(withDictionary: value)
            self.appendChat(newChat)
        })
    }
    
    func appendChat(_ chat: Chat){
        currentChats.append(chat)
        chatTableView.reloadData()
    }
    
    func uploadImage(image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let imageName = ("image \(convertedTimeStamp).jpeg")
        
        //also have png representation
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        storageRef.child(imageName).put(imageData, metadata: metadata) { (meta, error) in
            
            self.dismiss(animated: true, completion: nil)
            
            if error != nil {
                return
            }
            
            if let downloadUrl = meta?.downloadURL() {
                self.imageUrl = downloadUrl
                self.sendChat()
            } else {
                //error
            }
        }
    }
}



extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage(image: image)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as? ChatCell
            else {
                return UITableViewCell()
        }
        
        let chat = currentChats[indexPath.row]
        
        if chat.realImage != nil {
            
            cell.imageHeight.constant = 180
            cell.chatImageView.image = chat.realImage
        } else {
            cell.imageHeight.constant = 0
            if let url = chat.image {
                dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, eror) in
                    guard let validData = data else {return}
                    
                    guard let image = UIImage(data: validData) else { return }
                    self.reloadCell(atIndexPath: indexPath, withImage: image)
                    
                    //                cell.chatImageView.image = UIImage(data: validData)
                    //
                    //                DispatchQueue.main.async {
                    //                    cell.imageHeight.constant = 180
                    //                    cell.layoutIfNeeded()
                    //
                    //                }
                    
                    // set the image heiht
                })
                dataTask?.resume()
            }
    
        }
        // set the height = 0
        
        
        cell.senderLabel.text = chat.senderName
        cell.msgLabel.text = chat.text
        cell.timestampLabel.text = chat.timeAgo()
        
        return cell
    }
    
    func reloadCell(atIndexPath indexPath: IndexPath, withImage image: UIImage){
        
        
        let chat = currentChats[indexPath.row]
        chat.realImage = image
        DispatchQueue.main.async {
            self.chatTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
