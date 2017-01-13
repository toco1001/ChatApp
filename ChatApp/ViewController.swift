//
//  ViewController.swift
//  ChatApp
//
//  Created by toco on 12/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var webView: UIWebView!
  var name = String()
  var base64String = String()
  var uuid = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    webView?.scrollView.bounces = false
    guard let contentsOfFile = Bundle.main.path(forResource: "cc", ofType: "gif") else { return }
    let data = NSData(contentsOfFile: contentsOfFile)
    if let gifData = data as? Data {
      webView?.load(gifData, mimeType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL() as URL)
    }
    
    
    let fbLoginButton = FBSDKLoginButton()
    let rect = CGRect(x: self.view.frame.size.width/10, y: self.view.frame.size.height/2, width: self.view.frame.size.width-(self.view.frame.size.width/10), height: 50)
    fbLoginButton.frame = rect
    self.view.addSubview(fbLoginButton)
    
    
    
    fbLoginButton.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
    if error != nil {
      //エラーのとき
      print("エラーです")
      print(error)
      
    } else if result.isCancelled {
      
    } else {
      //取得
      fetchFacebookUserInfo()
    }
  }
  
  //ユーザー情報の取得
  func fetchFacebookUserInfo() {
    
    //ユーザー情報を持ってくる
    if FBSDKAccessToken.current() != nil {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name"]).start{
        (connection, result, error) in
        
        
        self.name = (result as AnyObject).value(forKey: "name") as! String
        let id = (result as AnyObject).value(forKey: "id")
        
        let url = URL(string: "https://graph.facebook.com/\(id!)/picture?type=large&return_ssl_resorces=1")
        let dataURL = NSData(contentsOf: url!)
        
        self.base64String = dataURL!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //アプリ内に保存をする
        
        
      }
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("Did logout")
  }
  
}

