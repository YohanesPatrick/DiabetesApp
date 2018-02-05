//
//  MoodViewController.swift
//  DiabetesMU
//
//  Created by Yohanes Patrik Handrianto on 1/31/18.
//  Copyright © 2018 Yohanes Patrik Handrianto. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
//import FirebaseDatabase
import Firebase

class MoodViewController: UIViewController {
  
    var survey = SurveyObj()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublicData()
    
    }
  
    @IBAction func takeSurvey(_ sender: Any) {
        // Build the survey.
        let taskViewController = survey.buildSurv()
        // For resignation of survey.
        taskViewController.delegate = self
        // Trigger the survey.
        self.present(taskViewController, animated: true, completion: nil)
        //present(taskViewController, animated: true, completion: nil)
    }
    
    func getPublicData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("blueprints").observe(DataEventType.childAdded, with: { (snapshot) in
            // warning: handle all child action events, like changed or removed
            //self.survey = SurveyObj()
            self.survey = self.getSurveyData(snapshot: snapshot)
            
            let taskViewController = self.survey.buildSurv()
            // For resignation of survey.
            taskViewController.delegate = self
            if(self.survey.takable.outputDirectory == nil){
                self.survey.takable.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                //let path = Bundle.main.path(forResource: snapshot.key, ofType: "png")
                //survey.takable.outputDirectory = NSURL.fileURL(withPath: path!)
            }
        })
    }
    
    func getSurveyData(snapshot:DataSnapshot)->SurveyObj{
        let survey = SurveyObj()
        
        survey.id = snapshot.key
        if let name = snapshot.childSnapshot(forPath: "name").value as? String{
            survey.name = name
        }
        if let username = snapshot.childSnapshot(forPath: "user").value as? String{
            survey.username = username
        }
        
        if let snapshot = snapshot.childSnapshot(forPath: "survey").children.allObjects as? [DataSnapshot]{
            // Generate survey step by step.
            for rest in snapshot {
                let postDict = rest.value as? [String : AnyObject] ?? [:]
                
                let step = StepObj()
                var type = ""
                if let typeO = postDict["type"] as? String{
                    type = typeO
                }
                
                switch type {
                case "MultipleChoice":
                    let questionTitle = postDict["title"] as? String ?? ""
                    let questions = postDict["choices"] as? [String] ?? ["ERROR a","ERROR b"]
                    
                    let archiver = NSKeyedArchiver()
                    archiver.encode(questionTitle, forKey: "title")
                    archiver.encode(questions, forKey: "questions")
                    archiver.finishEncoding()
                    step.title = archiver.encodedData.base64EncodedString()
                    step.id = postDict["id"] as? String ?? ""
                    step.type = type
                    step.condit = postDict["conditionID"] as? String ?? ""
                    step.on = postDict["on"] as? String ?? ""
                    NSLog("-\(questionTitle)")
                    if let multiSelect = postDict["multiSelect"] as? Bool {
                        step.multiSelect = multiSelect
                        NSLog("-\(questionTitle) \(multiSelect)")
                    }
                    
                case "Scale":
                    let questionTitle = postDict["title"] as? String ?? ""
                    let choices = postDict["choices"] as? [String] ?? ["ERROR a","ERROR b"]
                    
                    let archiver = NSKeyedArchiver()
                    archiver.encode(questionTitle, forKey: "title")
                    archiver.encode(choices, forKey: "choices")
                    archiver.finishEncoding()
                    step.title = archiver.encodedData.base64EncodedString()
                    step.id = postDict["id"] as? String ?? ""
                    step.type = type
                    step.condit = postDict["conditionID"] as? String ?? ""
                    step.on = postDict["on"] as? String ?? ""
                    
                case "scheduledNotification":
                    step.notifMessage = postDict["notifMessage"] as? String ?? "Take your survey!"
                    step.repeatBool = postDict["notifRepeat"] as? Bool ?? false
                    step.notifWhen = postDict["notifWhen"] as? String ?? ""
                    step.title = "Notification"
                    step.id = "Notification"
                    step.type = type
                    
                case "randomNotification":
                    step.notifMessage = postDict["notifMessage"] as? String ?? "Take your survey!"
                    step.notifFrom = postDict["notifFrom"] as? String ?? ""
                    step.notifTo = postDict["notifTo"] as? String ?? ""
                    step.notifUntil = postDict["notifUntil"] as? String ?? ""
                    step.notifTimes = Int(postDict["notifTimes"] as? Int16 ?? 0)
                    step.title = "Notification"
                    step.id = "Notification"
                    step.type = type
                    
                default:
                    step.title = postDict["title"] as? String ?? ""
                    step.id = postDict["id"] as? String ?? ""
                    step.type = type
                    step.condit = postDict["conditionID"] as? String ?? ""
                    step.on = postDict["on"] as? String ?? ""
                }
                
                survey.questions.append(step)
            }
        }
        
        return survey
    }
}
   
extension MoodViewController:ORKTaskViewControllerDelegate {
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        //gets info
        //data output vvv
        NSLog("----")
        let para:NSMutableDictionary = NSMutableDictionary()
        let taskResult = taskViewController.result
        let taskIdentifier = taskViewController.task!.identifier;
        
        if(reason != ORKTaskViewControllerFinishReason.discarded){
            
            //here is where you can develop new data output from the surveys
            //DATA OUT DIR
            for result in taskResult.results! {
                let stepResult = result as! ORKStepResult
                for result in stepResult.results! {
                    if let questionResult = result as? ORKChoiceQuestionResult{
                        if(questionResult.answer != nil){
                            let answer = questionResult.answer! as! [String]
                            para.setValue(answer.joined(separator: ","), forKey: questionResult.identifier)
                        }
                    }
                    if let questionResult = result as? ORKTextQuestionResult{
                        if(questionResult.answer != nil){
                            
                            let answer = questionResult.answer! as! String
                            para.setValue(answer, forKey: questionResult.identifier)
                        }
                    }
                    if let questionResult = result as? ORKTimeIntervalQuestionResult {
                        if(questionResult.answer != nil){
                            let answer = questionResult.intervalAnswer
                            para.setValue(answer, forKey: questionResult.identifier)
                        }
                    }
                    if let questionResult = result as? ORKDateQuestionResult{
                        if(questionResult.answer != nil){
                            let answer = questionResult.dateAnswer!
                            let dfo = DateFormatter()
                            dfo.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            para.setValue(dfo.string(from: answer), forKey: questionResult.identifier)
                        }
                    }
                    if let questionResult = result as? ORKTimeOfDayQuestionResult{
                        if(questionResult.answer != nil){
                            let answer = questionResult.dateComponentsAnswer
                            let answerString = "\(answer!.hour!):\(answer!.minute!)"
                            para.setValue(answerString, forKey: questionResult.identifier)
                        }
                    }
                    //                    if let filePath = self.surveys.last?.takable.outputDirectory?.path, let image = UIImage(contentsOfFile: filePath) {
                    //                        NSLog("!!!!")
                    //                        // /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles
                    //                        // 2017-09-29 00:59:24.942125-0500
                    //                    }
                }
            }
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let uid = ""//FIR
            // let now = NSDate().timeIntervalSince1970
            let now = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateString = df.string(from: now)
            
            ref.child("data").child(taskIdentifier).child("answers").childByAutoId().updateChildValues(["timeStamp":dateString, "surveyData":para, "userID":uid ?? ""])
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
