//
//  ViewController.swift
//  ChatApp
//
//  Created by toco on 12/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

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
    
    
    if UserDefaults.standard.object(forKey: "OK") != nil {
      print("１度ログインしているので、次の画面へ画面遷移")
      performSegue(withIdentifier: "next", sender: nil)
    }
    
    
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
        
        guard let nameValue = (result as AnyObject).value(forKey: "name") as? String else { return }
        self.name = nameValue
        let id = (result as AnyObject).value(forKey: "id")
        guard let url = URL(string: "https://graph.facebook.com/\(id!)/picture?type=large&return_ssl_resorces=1") else { return }
        guard let dataURL = NSData(contentsOf: url) else { return }
        
        // Data型からString型に変換する
        self.base64String = dataURL.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //アプリ内に保存をする
        UserDefaults.standard.set(self.base64String, forKey: "profile_image")
        UserDefaults.standard.set(self.name, forKey: "name")
        
        //Firebase と接続する
        // 信用のおける
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential){
          (user, error) in
          if UserDefaults.standard.object(forKey: "OK") != nil {
            // 1度ログインしているので飛ばします
            
          } else {
            self.uuid = user!.uid
            self.createNewUserDB()
          }
        }
      }
      performSegue(withIdentifier: "next", sender: nil)
    }
  }
  
  func createNewUserDB() {
    //サーバーに情報を飛ばす
    // Firebaseのデータベースを登録する
    let firebase = FIRDatabase.database().reference(fromURL: "https://chatapp-d6436.firebaseio.com/")
    //サーバに飛ばす箱をつくる
    let user: NSDictionary = ["username":self.name, "profileImage":self.base64String, "uuid":self.uuid]
    
    firebase.child("users").childByAutoId().setValue(user)
    
    UserDefaults.standard.set("OK", forKey: "OK")
    
    
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("Did logout")
  }
  
}

