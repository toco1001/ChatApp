//
//  RoomViewController.swift
//  ChatApp
//
//  Created by toco on 14/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var roomImageView = UIImageView()
  var roomNameLabel = UILabel()
  var roomName = String()
  var roomImageArray = ["one.png", "two.png", "three.png", "four.png", "five.png", "six.png", "seven.png"]
  var roomNameArray = ["新入社員雑談", "助け合い広場", "業務報告", "話そう会", "東京都民憩いの場", "関西人ちょっと集ろか"]
  
  var cellNumber: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.reloadData()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chat" {
      let chatVC: ChatViewController = segue.destination as! ChatViewController
      chatVC.cellNumber = cellNumber
      chatVC.roomName = roomName
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cellNumber = indexPath.row
    roomName = roomNameArray[indexPath.row]
    
    //プッシュで画面遷移
    performSegue(withIdentifier: "chat", sender: nil)
  }
  
  
}

extension RoomViewController: UITableViewDelegate {}

extension RoomViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.selectionStyle = .none
    
    if let imageView = cell.viewWithTag(1) as? UIImageView {
      roomImageView = imageView
    }
    if let label = cell.viewWithTag(2) as? UILabel {
      roomNameLabel = label
    }
    
    roomImageView.image = UIImage(named: roomImageArray[indexPath.row])
    roomNameLabel.text = roomNameArray[indexPath.row]
    
    
    return cell
  }
  
  
}
