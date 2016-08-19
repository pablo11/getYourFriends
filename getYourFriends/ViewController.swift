//
//  ViewController.swift
//  getYourFriends
//
//  Created by Pablo Pfister on 18/08/16.
//  Copyright © 2016 Pablo Pfister. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        //request permissions
        loginButton.readPermissions = ["public_profile", "user_friends"]
        
        fetchProfile()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func fetchProfile() {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            //get personal info
            let parameters = ["fields" : "first_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, result, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                //get and set first name
                if let firstName = result["first_name"] as? String {
                    self.nameLbl.text = "Hi \(firstName), here are your friends!"
                }
                
                //get and set profile image url
                if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, imgUrl = data["url"] as? String {
                    if let url = NSURL(string: imgUrl) {
                        if let data = NSData(contentsOfURL: url) {
                            self.profileImg.image = UIImage(data: data)
                        }
                    }
                }
            })
            
            //get friends
            FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["fields" : "name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if let friendsArray = result["data"] as? [NSDictionary] {
                    for friend in friendsArray {
                        var friendName: String = ""
                        if let name = friend["name"] as? String {
                            friendName = name
                        }
                        
                        if let pict = friend["picture"] as? NSDictionary, pictData = pict["data"] as? NSDictionary, url = pictData["url"] as? String {
                            self.friends.append((friendName, url))
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            })
            
        } else {
            print("Trying to fetch profile but user is not logged in!")
            restoreDefaultConfig()
        }
        
    }
    
    func restoreDefaultConfig() {
        nameLbl.text = "Log in to see your friends!"
        profileImg.image = UIImage(named: "defaultImg")
        friends = []
        tableView.reloadData()
    }
    
    //FBSDK methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let err = error {
            print(err.debugDescription)
            return
        }
        
        fetchProfile()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User is logged out")
        restoreDefaultConfig()
    }
    
    //tableView methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? FriendCell {
            let friend = friends[indexPath.row]
            cell.configCell(friend.0, imgUrl: friend.1)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

