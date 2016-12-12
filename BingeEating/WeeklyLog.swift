//
//  WeeklyLog.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 12/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation


struct WeeklyLog{
    let logId: String!
    var binges: Int!
    var vld: Int!
    var goodDays: Int!
    var weight: Int!
    var fv: Int!
    var activites: Int!
    var events: String!
    var week: Int!
    
    init() {
        self.logId = " "
        self.activites = 0
        self.vld = 0
        self.binges = 0
        self.goodDays = 0
        self.weight = 0
        self.fv = 0
        self.events = " "
        self.week = 0
    }
    
    init(jsonObject: [String: Any]) {
        self.logId = jsonObject["LogId"] as? String ?? " "
        self.activites = jsonObject["PhysicalActivity"] as? Int ?? 0
        self.binges = jsonObject["Binges"] as? Int ?? 0
        self.vld = jsonObject["VLD"] as? Int ?? 0
        self.weight = jsonObject["WEIGHT"] as? Int ?? 0
        self.fv = jsonObject["FruitVegetableServings"] as? Int ?? 0
        self.events = jsonObject["Events"] as? String ?? "None"
        self.week = jsonObject["Week"] as? Int ?? 0
        self.goodDays = jsonObject["GoodDays"] as? Int ?? 0
    }
}
