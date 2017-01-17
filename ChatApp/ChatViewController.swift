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
  
  var cellNumber: Int = 0
  var roomName = String()
  var messages: [JSQMessage] = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outcomingBubble: JSQMessagesBubbleImage!
  var incomingAvatar: JSQMessagesAvatarImage!
  var outcomingAvatar: JSQMessagesAvatarImage!
  
  var userNameLabel = String()
  var backgroundImageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    backgroundImageView.frame = rect
    
    ///背景画像を反映
    
    
    ///チャットをスタートさせる
    
    ///情報をリアルタイムで取得する
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
