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
  var cellNumber: Int = 0
  var roomName = String()
  var messages: [JSQMessage] = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  var incomingAvatar: JSQMessagesAvatarImage!
  var outgoingAvatar: JSQMessagesAvatarImage!
  var roomNameLabelText: String!
  var backgroundImageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    backgroundImageView.frame = rect
    
    ///背景画像を反映
    
    // roomの名前を反映
    roomNameLabel?.text = roomNameLabelText
    
    ///チャットをスタートさせる
    chatStart()
    ///情報をリアルタイムで取得する
    
    // Avatarがいない
    self.collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
  }
  
  func chatStart() {
    automaticallyAdjustsScrollViewInsets = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
