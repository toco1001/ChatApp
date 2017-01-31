//
//  ChatViewController.swift
//  ChatApp
//
//  Created by toco on 15/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
  
  @IBOutlet weak var roomNameLabel: UILabel!
  
  
  var decodedImage1 = UIImage()
  var decodedImage2 = UIImage()
  
  var cellNumber: Int = 0
  var roomName = String()
  var messages: [JSQMessage] = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  var incomingAvatar: JSQMessagesAvatarImage!
  var outgoingAvatar: JSQMessagesAvatarImage!
  var backgroundImageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    backgroundImageView.frame = rect
    
    ///背景画像を反映
    if UserDefaults.standard.object(forKey: "back_image") != nil {
      let decodeData = UserDefaults.standard.object(forKey: "back_image")
      let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
      let decodedImage10 = UIImage(data: decodedData as! Data)
      backgroundImageView.image = decodedImage10
      self.collectionView?.backgroundView = backgroundImageView
    }
    
    // roomの名前を反映
    roomNameLabel?.text = roomName
    
    ///チャットをスタートさせる
    chatStart()
    ///情報をリアルタイムで取得する
    getInfo()
    
    // Avatarがいない
    self.collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
  }
  
  func chatStart() {
//    inputToolbar.contentView.leftBarButtonItem = nil
    automaticallyAdjustsScrollViewInsets = true
    if UserDefaults.standard.object(forKey: "name") != nil {
      self.senderId = FIRAuth.auth()?.currentUser?.uid
      self.senderDisplayName = UserDefaults.standard.object(forKey: "name") as? String
    }
    
    // 吹き出しの設定
    let bubbleFactory = JSQMessagesBubbleImageFactory()
    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage1, diameter: 64)
    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage2, diameter: 64)
    
    // メッセージの配列の初期化
    self.messages = []
  }
  
  func getInfo() {
    // 情報を取得する際に左上にぐるぐるをつける
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let firebase = FIRDatabase.database().reference(fromURL: "https://chatapp-d6436.firebaseio.com/").child(String(cellNumber)).child("message")
    firebase.observe(.childAdded, with: {
      (snapshot) in
      if let dictionary = snapshot.value as? [String:AnyObject] {
        let snapshotValue = snapshot.value as! NSDictionary
        snapshotValue.setValuesForKeys(dictionary)
        let text = snapshotValue["text"] as? String
        let senderId = snapshotValue["from"] as? String
        let name = snapshotValue["name"] as? String
        let message = JSQMessage(senderId: senderId, displayName: name, text: text)
        self.messages.append(message!)
        self.finishReceivingMessage()
      }
    })
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    let rootRef = FIRDatabase.database().reference(fromURL: "https://chatapp-d6436.firebaseio.com/").child(String(cellNumber)).child("message")
    let timestamp = Int(NSDate().timeIntervalSince1970)
    let post: Dictionary<String, Any>? = ["from":senderId, "name":senderDisplayName, "text":text, "timestamp": timestamp]
    let postRef = rootRef.childByAutoId()
    postRef.setValue(post)
    self.inputToolbar.contentView.textView.text = ""
    
  }
  
  // 参照するメッセージを返す
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return self.messages[indexPath.item]
  }
  
  // 背景を返す
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = self.messages[indexPath.row]
    if message.senderId == senderId {
      return outgoingBubble
    } else {
      return incomingBubble
    }
  }
  
  // アバターを返す
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    let message = self.messages[indexPath.row]
    if message.senderId == senderId {
      return outgoingAvatar
    } else {
      return incomingAvatar
    }
  }
  
  // メッセージの総数を返す
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  // メッセージの位置を決める
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath as IndexPath) as! JSQMessagesCollectionViewCell
    if messages[indexPath.row].senderId == senderId {
      cell.textView?.textColor = UIColor.white
    } else {
      cell.textView?.textColor = UIColor.darkGray
    }
    return cell
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func back(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
