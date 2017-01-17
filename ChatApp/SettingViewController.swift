//
//  SettingViewController.swift
//  ChatApp
//
//  Created by toco on 17/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var profileNameLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let ud = UserDefaults.standard.object(forKey: "profile_image") {
      //デコードして取り出す
      let decodeData = ud
      let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
      let decodedImage = UIImage(data: decodedData! as Data)
      
      profileImageView.image = decodedImage
      profileNameLabel.text = UserDefaults.standard.object(forKey: "name") as! String
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func openAlbum(_ sender: Any) {
  }
  @IBAction func launchCamera(_ sender: Any) {
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
