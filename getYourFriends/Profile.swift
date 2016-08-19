//
//  Profile.swift
//  getYourFriends
//
//  Created by Pablo Pfister on 18/08/16.
//  Copyright © 2016 Pablo Pfister. All rights reserved.
//

import Foundation

class Profile {
    private var _firstName: String!
    private var _imgUrl: NSURL!
    private var _friends: [String] = []
    
    var firstName: String {
        get {
            return _firstName
        }
        set(newFirstName) {
            _firstName = newFirstName
        }
    }
    
    var imgUrl: NSURL? {
        get {
            if let url = _imgUrl {
                return url
            } else {
                return nil
            }
        }
        set(newUrl) {
            _imgUrl = newUrl
        }
    }
    
    init() {}
}
