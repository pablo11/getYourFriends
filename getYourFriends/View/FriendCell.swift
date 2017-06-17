//
//  FriendCell.swift
//  getYourFriends
//
//  Created by Pablo Pfister on 19/08/16.
//  Copyright © 2016 Pablo Pfister. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configCell(_ friendName: String?, imgUrl: String?) {
        if let name = friendName {
            nameLbl.text = name
        }
        
        DispatchQueue.main.async {
            if let img = imgUrl, let url = URL(string: img) {
                if let data = try? Data(contentsOf: url) {
                    self.profileImg.image = UIImage(data: data)
                }
            }
        }
    }

}
