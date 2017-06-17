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
    
    var friends: [(name: String, imgUrl: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        // Request permissions
        loginButton.readPermissions = ["public_profile", "user_friends"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchProfile()
    }
    
    // MARK: FBSDK methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let err = error {
            print(err.localizedDescription)
            return
        }
        
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User is logged out")
        restoreDefaultConfig()
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    // MARK: UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell {
            let friend = friends[indexPath.row]
            cell.configCell(friend.name, imgUrl: friend.imgUrl)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: private methods

    private func fetchProfile() {
        if let _ = FBSDKAccessToken.current() {
            // Get personal info
            let parameters = ["fields" : "first_name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let res = result as? [String:Any] {
                    // First name
                    if let firstName = res["first_name"] as? String {
                        self.nameLbl.text = "Hi \(firstName), here are your friends!"
                    }
                
                    // Profile image url
                    if let picture = res["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let imgUrl = data["url"] as? String {
                        if let url = URL(string: imgUrl) {
                            if let data = try? Data(contentsOf: url) {
                                self.profileImg.image = UIImage(data: data)
                            }
                        }
                    }
                }
            })
            
            // Get friends
            FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: ["fields" : "name, picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let res = result as? [String:Any] {
                    if let friendsArray = res["data"] as? [NSDictionary] {
                        for friend in friendsArray {
                            var friendName: String = ""
                            if let name = friend["name"] as? String {
                                friendName = name
                            }
                        
                            if let pict = friend["picture"] as? NSDictionary, let pictData = pict["data"] as? NSDictionary, let url = pictData["url"] as? String {
                                self.friends.append((friendName, url))
                            }
                        }
                    
                        self.tableView.reloadData()
                    }
                }
            })
            
        } else {
            print("Trying to fetch profile but user is not logged in!")
            restoreDefaultConfig()
        }
        
    }
    
    private func restoreDefaultConfig() {
        nameLbl.text = "Log in to see your friends!"
        profileImg.image = UIImage(named: "defaultImg")
        friends = []
        tableView.reloadData()
    }
}

