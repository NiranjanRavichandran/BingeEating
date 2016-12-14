//
//  Question.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/14/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation

struct Question {
    let questionId: String!
    let question: String!
    var options: [String]!
    var answer: Int!
    
    init(jsonObject: [String: Any]) {
        self.questionId = jsonObject["QuestionId"] as? String ?? " "
        self.question = jsonObject["Question"] as? String ?? " "
        let opts = jsonObject["Options"] as? String ?? " "
        let newopts = String(opts.characters.dropFirst())
        let dropped = String(newopts.characters.dropLast())
        self.options = dropped.components(separatedBy: ",")
        self.answer = 0
        if let correct = jsonObject["Answer"] as? String {
            if correct == "b" {
                self.answer = 1
            }else if correct == "c" {
                self.answer = 2
            }else if correct == "d" {
                self.answer = 3
            }
        }
    }
}
