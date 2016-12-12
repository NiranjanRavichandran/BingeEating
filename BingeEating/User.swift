//
//  User.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/11/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation

struct User {
    let id: String!
    let notes: String!
    let userId: String!
    var isNotesVisible: Bool!
    let username: String!
//    let password: String!
    let role: String!
    let level: Int!
    let supportterId: String!
    let scores: Int!
    var isMessages: Bool!
    var isImageTagging: Bool!
    
    
    init(jsonObject: [String: Any]) {
        self.id = jsonObject["Id"] as? String ?? " "
        self.notes = jsonObject["Notes"] as? String ?? " "
        self.userId = jsonObject["UserId"] as? String ?? " "
        self.username = jsonObject["Username"] as? String ?? " "
        self.role = jsonObject["Role"] as? String ?? " "
        self.level = jsonObject["Level"] as? Int ?? 0
        self.supportterId = jsonObject["SupporterId"] as? String ?? " "
        self.scores = jsonObject[""] as? Int ?? 0
        self.isNotesVisible = false
        if let isVis = jsonObject["IsVisible"] as? Int {
            if isVis == 0 {
                self.isNotesVisible = true
            }
        }
        self.isMessages = false
        if let isMessg = jsonObject["Messages"] as? Int {
            if isMessg == 0 {
                self.isMessages = true
            }
        }
        self.isImageTagging = false
        if let isTagging = jsonObject["ImageTagging"] as? Int {
            if isTagging == 0 {
                self.isImageTagging = true
            }
        }
    }
}
