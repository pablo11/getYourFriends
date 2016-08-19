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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(friendName: String?, imgUrl: String?) {
        if let name = friendName {
            nameLbl.text = name
        }
        
        if let img = imgUrl, url = NSURL(string: img) {
            if let data = NSData(contentsOfURL: url) {
                profileImg.image = UIImage(data: data)
            }
        }
        
    }

}
