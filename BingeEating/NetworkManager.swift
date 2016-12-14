//
//  NetworkManager.swift
//  BingeEating
//
//  Created by Niranjan Ravichandran on 11/9/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation
import Alamofire

enum AppEndPoints: String {
    case base = "http://52.89.68.106:8080"
    case login = "/signin"
    case coachMessage = "/getMotivationalMessage"
    case postDailyLog = "/postDailyLog"
    case postPhyLog = "/postPhysicalDailyLog"
    case postWeeklyLog = "/postWeeklyLog"
    case getDailyLog = "/getDailyLog"
    case getPhyLogs = "/getPhysicalDailyLog"
    case getProgress = "/getProgress"
    case getWeeklyLog = "/getWeeklyLog"
    case getNewWeeklyLog = "/getNewWeeklyLog"
    case getAppointments = "/getMyAppointments"
    case getNotes = "/viewNotes"
    case addNewNote = "/addNotes"
    case updateNotes = "/editNotes"
    case deleteNotes = "/deleteNotes"
    case getSignedURL = "/"
    case changePassword = "/changePassword"
    case getAllScores = "/getAllScores"
    case updateScore = "/updateScore"
    case getQuestions = "/getQuestions"
}

enum BEErrorMessages: String {
    case commom = "Someting went wrong"
}

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    func loginWithUsername(username: String, passowrd: String, onSuccess success: @escaping (String) -> Void, onError error: (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.login.rawValue, method: .post, parameters: ["username": username, "password": passowrd], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let jsonResponse = response.result.value as? [String: Any] {
                if let data = jsonResponse["data"] as? [String: Any] {
                    if let token = data["token"] as? String {
                        success(token)
                    }
                }
            }
        }
    }
    
    
    //To be optimised later...
    func getMessageFromServer(token: String, keyword: String, onSuccess success: @escaping (String) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.coachMessage.rawValue, method: .post, parameters: ["token": token, "label": keyword], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let jsonResponse = response.result.value as? [String: Any] {
                
                if let messages = jsonResponse["message"] as? [[String: Any]] {
                    success(messages.first!["Message"] as! String)
                }
            }
        }
    }
    
    //Post daily log
    func postDailyLog(token: String, dailylogItem: DailyLogItem, onSuccess success: @escaping () -> Void, onError error: @escaping (String) -> Void) {
        print("###", dailylogItem)
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.postDailyLog.rawValue, method: .post, parameters: ["token": token, "logId": dailylogItem.logId, "time": dailylogItem.eatTime, "consumed": dailylogItem.foodAndDrink, "servings": dailylogItem.servings, "binge": dailylogItem.didBinge.getRaw(), "vl": dailylogItem.vomitOrLaxative.getRaw() , "cs": dailylogItem.contextSetting, "feelings": dailylogItem.feelings, "image": dailylogItem.imageUrl ?? "", "newImage": dailylogItem.isNewImage], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("*****", response.result.description)
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errorStat = jsonResponse["error"] as? Bool {
                    if !errorStat {
                        success()
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func postPhysicalActivity(token: String, activityItem: PhysicalLogItem, onSuccess success: @escaping () -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.postPhyLog.rawValue, method: .post, parameters: ["token": token, "logId": activityItem.logId, "time": activityItem.time, "minutes": activityItem.duration, "workout": activityItem.typeOfActivity], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                print("@@@", jsonResponse)
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        success()
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getDailyLog(token: String, forDate date: String, onSuccess success: @escaping ([DailyLogItem]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getDailyLog.rawValue, method: .post, parameters: ["token": token, "date": date], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let isError = jsonResponse["error"] as? Bool {
                    if !isError {
                        if let logs = jsonResponse["data"]?["dailyLogs"] as? [[String: Any]] {
                            var dailyLogs = [DailyLogItem]()
                            for item in logs {
                                dailyLogs.append(DailyLogItem(jsonObject: item))
                            }
                            success(dailyLogs)
                        }
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getPhyLogs(token: String, date: String, onSuccess success: @escaping ([PhysicalLogItem]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getPhyLogs.rawValue, method: .post, parameters: ["token" : token, "date": date], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String : AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        var phyLogs = [PhysicalLogItem]()
                        print("@@@@", jsonResponse)
                        if let logs = jsonResponse["data"]?["dailyLogs"] as? [[String: Any]] {
                            for item in logs {
                                phyLogs.append(PhysicalLogItem(jsonObject: item))
                            }
                            success(phyLogs)
                        }
                    }
                }else {
                    error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getUserProgress(token: String, onSuccess success: @escaping (Int) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getProgress.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: Any] {
                if let status = jsonResponse["error"] as? Bool {
                    if !status { //Success
                        if let data = jsonResponse["data"] as? [String: AnyObject] {
                            if let progress = data["progress"] as? Int {
                                success(progress)
                            }else {
                                error(data["message"] as? String ?? BEErrorMessages.commom.rawValue)
                            }
                        }
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }
            }
        }
    }
    
    func getAppointments(token: String, onSuccess success: @escaping ([[String: Any]]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getAppointments.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: Any] {
                if let status = jsonResponse["error"] as? Bool {
                    if !status {
                        if let data = jsonResponse["data"] as? [String: Any] {
                            if let appointments = data["appointments"] as? [[String: Any]] {
                                success(appointments)
                            }
                        }else {
                            error(BEErrorMessages.commom.rawValue)
                        }
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }
            }
        }

    }
    
    func getSignedURL(token: String, onSuccess success: @escaping (String) -> Void, onError error: @escaping (String) -> Void) {
            Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getSignedURL.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let jsonResponse = response.result.value as? [String: AnyObject] {
                    if let errStat = jsonResponse["error"] as? Bool {
                        if !errStat {
                            success(jsonResponse["data"]?["str"] as? String ?? " ")
                        }else {
                            error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                        }
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }
    }
    
    func saveImageToServer(token: String, postURL: String, image: UIImage, onSuccess success: @escaping (Bool) -> Void, onError error: @escaping (String) -> Void) {
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let request = Alamofire.upload(imageData, to: postURL, method: .put, headers: ["Content-Type":"image/jpeg"])
            request.validate()
            request.response(completionHandler: { (response) in
                print("AWS***", response.response)
                if response.response?.statusCode == 200 {
                    success(true)
                }else {
                    error(response.response.debugDescription)
                }
            })
        }
    }
    
    func getWeeklyLog(token: String, onSuccess success: @escaping ([WeeklyLog]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getWeeklyLog.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let status = jsonResponse["error"] as? Bool {
                    if !status {
                        if let logs = jsonResponse["data"]?["weeklyLog"] as? [[String: Any]] {
                            var weeklyLogs = [WeeklyLog]()
                            for item in logs {
                                weeklyLogs.append(WeeklyLog(jsonObject: item))
                            }
                            success(weeklyLogs)
                        }
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }
        }
    }
    
    func getNewWeeklyLog(token: String, week: Int, onSuccess success: @escaping (WeeklyLog) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getNewWeeklyLog.rawValue, method: .post, parameters: ["token": token, "week": week], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let status = jsonResponse["error"] as? Bool {
                    if !status {
                        if let log = jsonResponse["data"]?["WeeklyLog"] as? [String: Any] {
                            success(WeeklyLog(jsonObject: log))
                        }
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }
        }
    }
    
    func postWeeklyLog(token: String, logId: String, binges: Int, vld: Int, physical: Int, fv: Int, goodDays: Int, events: String, onSuccess success: @escaping () -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.postWeeklyLog.rawValue, method: .post, parameters: ["token": token, "LogId": logId, "binges": binges, "vld": vld, "physical": physical, "fv": fv, "events": events, "goodDays": goodDays], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: Any] {
                print(jsonResponse)
                if let status = jsonResponse["error"] as? Bool {
                    if !status {
                        success()
                    }else {
                        error(BEErrorMessages.commom.rawValue)
                    }
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getNotes(token: String, onSuccess success: @escaping ([User]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getNotes.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let status = jsonResponse["error"] as? Bool {
                    if !status {
                        var notes = [User]()
                        print(jsonResponse)
                        if let uNotes = jsonResponse["data"]?["notes"] as? [[String: AnyObject]] {
                            for note in uNotes {
                                notes.append(User(jsonObject: note))
                            }
                            success(notes)
                        }
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func addNotes(token: String, notes: String, isVisible: Int, success: @escaping (Bool) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.addNewNote.rawValue, method: .post, parameters: ["token": token, "notes": notes, "isVisible": isVisible], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: Any] {
                //print("@@@", jsonResponse)
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        success(true)
                    }else {
                        success(false)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func updateNotes(token: String, note: User, success: @escaping (Bool) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.updateNotes.rawValue, method: .post, parameters: ["token": token, "notesId": note.id, "notes": note.notes, "isVisible": note.isNotesVisible.getRaw()], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                print("@@@", jsonResponse)
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        success(true)
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func deleteNotes(token: String, note: User, success: @escaping (Bool) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.deleteNotes.rawValue, method: .post, parameters: ["token": token, "notesId": note.id], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        success(true)
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func changePassword(token: String, with password: String, success: @escaping (_ user: User, _ token: String) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.changePassword.rawValue, method: .post, parameters: ["token": token, "password": password], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        if let data = jsonResponse["data"] as? [String: Any]{
                            success(User(jsonObject: data["user"] as! [String: Any]), data["token"] as! String)
                        }
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getAllScore(token: String, onSuccess success: @escaping ([Int]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getAllScores.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        if let data = jsonResponse["data"] as? [String: AnyObject] {
                            if let scores = data["scores"] as? [[String: Any]] {
                                var userScores = [Int]()
                                for item in scores {
                                    userScores.append(item["Score"] as! Int)
                                }
                                success(userScores)
                            }
                        }
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func updateScore(token: String, score: Int, onSuccess success: @escaping () -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.updateScore.rawValue, method: .post, parameters: ["token": token, "score": score], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        success()
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
    
    func getTriviaQuestions(token: String, onSuccess success: @escaping ([Question]) -> Void, onError error: @escaping (String) -> Void) {
        Alamofire.request(AppEndPoints.base.rawValue + AppEndPoints.getQuestions.rawValue, method: .post, parameters: ["token": token], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonResponse = response.result.value as? [String: AnyObject] {
                if let errStat = jsonResponse["error"] as? Bool {
                    if !errStat {
                        if let questList = jsonResponse["data"]?["questions"] as? [[String: AnyObject]] {
                            var questions = [Question]()
                            for item in questList {
                                questions.append(Question(jsonObject: item))
                            }
                            success(questions)
                        }
                    }else {
                        error(jsonResponse["data"]?["message"] as? String ?? BEErrorMessages.commom.rawValue)
                    }
                }else {
                    error(BEErrorMessages.commom.rawValue)
                }
            }else {
                error(BEErrorMessages.commom.rawValue)
            }
        }
    }
}
