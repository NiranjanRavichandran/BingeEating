//
//  DailyLog.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation

struct DailyLogItem {
    let logId: String!
    let logDate: String!
    var eatTime: String!
    var foodAndDrink: String!
    var servings: Int!
    var didBinge: Bool!
    var vomitOrLaxative: Bool!
    var feelings: String!
    var contextSetting: String!
    var isNewImage: Int! // Make it 1 for new image in updating the log
    var imageUrl: String?
    
    init() {
        self.logId = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.logDate = dateformatter.string(from: Date())
        self.didBinge = false
        self.vomitOrLaxative = true
        self.eatTime = dateformatter.string(from: Date())
        self.foodAndDrink = " "
        self.contextSetting = " "
        self.feelings = "None"
        self.servings = 0
        self.isNewImage = 0
    }
    
    init(jsonObject: [String: Any]) {
        self.logId = jsonObject["LogId"] as? String ?? " "
        self.logDate = jsonObject["Time"] as? String ?? " "
        if let binge = jsonObject["Binge"] as? Int {
            if binge == 0 {
                self.didBinge = false
            }else {
                self.didBinge = true
            }
        }else {
            self.didBinge = false
        }
        
        if let vl = jsonObject["VomitingOrLaxative"] as? Int {
            if vl == 0 {
                self.vomitOrLaxative = false
            }else {
                self.vomitOrLaxative = true
            }
        }else {
            self.vomitOrLaxative = false
        }
        self.eatTime = jsonObject["Time"] as? String ?? " "
        self.foodAndDrink = jsonObject["FoodOrDrinkConsumed"] as? String ?? " "
        self.feelings = jsonObject["Feelings"] as? String ?? " "
        self.contextSetting = jsonObject["ContextOrSetting"] as? String ?? " "
        self.servings = jsonObject["FVNumberOfServings"] as? Int ?? 0
        self.isNewImage = jsonObject["newImage"] as? Int ?? 0
        self.imageUrl = jsonObject["image"] as? String ?? " "
    }
    
    func objectToDict() -> [String: Any]{
        var returnDict = [String: Any]()
        returnDict["time"] = self.eatTime
        returnDict["consumed"] = self.foodAndDrink
        returnDict["binge"] = 0
        if self.didBinge! {
            returnDict["binge"] = 1
        }
        returnDict["vl"] = 0
        if self.vomitOrLaxative! {
            returnDict["vl"] = 1
        }
        returnDict["cs"] = self.contextSetting
        returnDict["feelings"] = self.feelings
        return returnDict
    }
}

struct PhysicalLogItem {
    let logId: String!
    var time: String!
    var typeOfActivity: String!
    var duration: Float!
    
    init() {
        self.logId = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.time = dateformatter.string(from: Date())
        self.typeOfActivity = " "
        self.duration = 0
    }
    
    init(jsonObject: [String: Any]) {
        self.logId = jsonObject["LogId"] as? String ?? " "
        self.typeOfActivity = jsonObject["PhysicalActivity"] as? String ?? " "
        self.duration = jsonObject["MinutesPerformed"] as? Float
        self.time = jsonObject["Time"] as? String ?? " "
    }
    
    func objectToDict() {
        var dict = [String: Any]()
        dict["time"] = self.time
        dict["minutes"] = self.duration
        dict["workout"] = self.typeOfActivity
    }
}
