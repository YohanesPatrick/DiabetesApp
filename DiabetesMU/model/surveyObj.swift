//
//  SurveyObj.swift
//  Survey
//
//  Created by William Morrison on 3/26/17.
//  Copyright © 2017 Wang Weihan. All rights reserved.
//

import Foundation
import CoreData
import ResearchKit
import UserNotifications

class SurveyObj{
    var name = ""
    var id = "TAdefault"
    var questions = [StepObj]()
    var takeTime = 0.0
    var username = ""
    var takable:ORKTaskViewController
    
    init(){
        var step = [ORKStep]()
        let instructionStep = ORKInstructionStep(identifier: "ERROR")//create an instruction survey step
        instructionStep.title = "ERROR Loading Survey"
        step += [instructionStep]
        let task = ORKNavigableOrderedTask(identifier: "ERROR", steps:step)
        takable = ORKTaskViewController(task: task, taskRun: UUID())
    }
    
    //    func saveQuestions(){
    //        for question in questions {
    //
    //            let q1 = Question(context: TemplateViewController().getContext())
    //            q1.title = question.title
    //            q1.type = question.type
    //            q1.id = question.id
    //            TemplateViewController().saveNote(q1: q1)
    //        }
    //    }
    
    func buildSurv()->ORKTaskViewController{
        var steps = [ORKStep]()
        var z = 0
        var fromID:String? = nil
        var toID:String? = nil
        var onID:String? = nil
        var defID:String? = nil
        
        for question in questions {
            if(question.type == "yesNo"){
                steps += self.makeBool(id: question.id, title: question.title)
                takeTime += 0.1
                //steps += self.makeTimeInt(id: id+"uuuiii2017aaa", title: title)
            } else if(question.type == "textSlide"){
                steps += self.makeTextSlide(id: question.id, title: question.title)
                takeTime += 0.1
            } else if(question.type == "textField"){
                steps += self.makeTextField(id: question.id, title: question.title)
                takeTime += 0.3
            }
            else if(question.type == "imgCapt"){
                steps += self.makeImgCapt(id: question.id)
                takeTime += 0.5
            }
            else if(question.type == "timeInt"){
                steps += self.makeTimeInt(id: question.id, title: question.title)
                takeTime += 0.4
                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
            }
            else if(question.type == "timeOfDay"){
                steps += self.makeTimeOfDay(id: question.id, title: question.title)
                takeTime += 0.4
                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
            }
            else if(question.type == "dateTime"){
                steps += self.makeDateTime(id: question.id, title: question.title)
                takeTime += 0.4
                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
            }
                //            else if(question.type == "MultipleChoice") {
                //                let data = Data(base64Encoded: question.title, options: .ignoreUnknownCharacters)
                //                let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
                //                let questionTitle = unarchiver.decodeObject(forKey: "title") as! String
                //                let questions = unarchiver.decodeObject(forKey: "questions") as! [String]
                //
                //                steps += makeMultipleChlice(id: question.id, title: questionTitle, choices: questions, multiSelect: question.multiSelect)
                //                takeTime += 0.6
                //            } else if(question.type == "Scale") {
                //                let data = Data(base64Encoded: question.title, options: .ignoreUnknownCharacters)
                //                let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
                //                let questionTitle = unarchiver.decodeObject(forKey: "title") as! String
                //                let choices = unarchiver.decodeObject(forKey: "choices") as! [String]
                //
                //                steps += makeScale(id: question.id, title: questionTitle, choices: choices)
                //                takeTime +=  0.6
                //            }
            else if(question.type == "scheduledNotification") {
                var dateInfo = DateComponents()
                var fullNameArr = question.notifWhen.components(separatedBy: ":")
                dateInfo.hour = Int(fullNameArr[0])
                dateInfo.minute = Int(fullNameArr[1])
                schedule(date: dateInfo, title: name, message: question.notifMessage, rep: question.repeatBool, id: id)
            } else if(question.type == "randomNotification") {
                let dateInfo = DateFormatter()
                dateInfo.dateFormat = "MMMM d, Y"
                let until = dateInfo.date(from: question.notifUntil)
                var fullNameArr = question.notifFrom.components(separatedBy: ":")
                let from = Int(fullNameArr[0])
                fullNameArr = question.notifTo.components(separatedBy: ":")
                let to = Int(fullNameArr[0])
                randomSchedule(from: from!, to: to!, until: until!, timesPerDay: question.notifTimes, title: name, message: question.notifMessage)
            }
            
            
            if(question.condit != ""){
                //work magic
                //z = z + 1
                //check itterator
                var ind = z
                if(z+1<questions.count){
                    ind+=1
                }
                let next = questions[ind]//itterate better
                defID = next.id
                fromID = question.id
                toID = question.condit
                onID = question.on
            }
            z+=1
        }
        
        steps += self.makeTextSlide(id: "^EOS", title: "Thank you for taking this TigerAware survey!")
        
        let task = ORKNavigableOrderedTask(identifier: id, steps:steps)
        if(fromID != nil){
            let inptResultSelector = ORKResultSelector(stepIdentifier: fromID, resultIdentifier: fromID!)
            
            
            let predicate = ORKResultPredicate.predicateForChoiceQuestionResult(with: inptResultSelector, expectedAnswerValue: onID as! NSCoding & NSCopying & NSObjectProtocol)
            let rule = ORKPredicateStepNavigationRule(resultPredicates: [predicate], destinationStepIdentifiers: [toID!], defaultStepIdentifier: defID, validateArrays: true)
            task.setNavigationRule(rule, forTriggerStepIdentifier: fromID!)
        }
        
        takable = ORKTaskViewController(task: task, taskRun: UUID())
        return ORKTaskViewController(task: task, taskRun: UUID())
        
    }
    
    func makeBool(id: String, title:String)->[ORKStep]{
        var step = [ORKStep]()
        // The text to display can be separate from the value coded for each choice:
        let textChoices = [
            ORKTextChoice(text: "Yes", value: "Yes" as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No", value: "No" as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        //let aStep = ORKAudioStep()
        
        step += [questionStep]
        
        return step
        
    }
    
    func makeTextSlide(id: String, title:String)->[ORKStep]{
        var step = [ORKStep]()
        // The text to display can be separate from the value coded for each choice:
        let instructionStep = ORKInstructionStep(identifier: id)//create an instruction survey step
        instructionStep.title = title
        step += [instructionStep]
        
        return step
        
    }
    
    func makeTextField(id: String, title:String)->[ORKStep]{
        var step = [ORKStep]()
        // The text to display can be separate from the value coded for each choice:
        
        let answerFormat = ORKAnswerFormat.textAnswerFormat()
        
        let textField = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        //textField.text = exampleDetailText
        
        step += [textField]
        
        return step
    }
    
    func makeImgCapt(id: String)->[ORKStep]{
        var step = [ORKStep]()
        
        let imageCaptureStep = ORKImageCaptureStep(identifier: id)
        imageCaptureStep.isOptional = false
        imageCaptureStep.accessibilityInstructions = NSLocalizedString("Your instructions for capturing the image", comment: "")
        imageCaptureStep.accessibilityHint = NSLocalizedString("Captures the image visible in the preview", comment: "")
        
        imageCaptureStep.title = "hello"
        
        step += [imageCaptureStep]
        
        return step
    }
    
    func makeTimeInt(id: String, title:String)->[ORKStep]{
        let answerFormat = ORKAnswerFormat.timeIntervalAnswerFormat()
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        return [questionStep]
    }
    
    func makeTimeOfDay(id: String, title:String)->[ORKStep]{
        let answerFormat = ORKAnswerFormat.timeOfDayAnswerFormat()
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        return [questionStep]
    }
    
    func makeDateTime(id: String, title:String)->[ORKStep]{
        let answerFormat = ORKAnswerFormat.dateTime()
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        return [questionStep]
    }
    
    // Make the multiple choice question
    func makeMultipleChlice(id: String, title: String, choices: [String], multiSelect: Bool) -> [ORKStep] {
        var step = [ORKStep]()
        // The text to display can be separate from the value coded for each choice:
        var textChoices = [ORKTextChoice]()
        // Add each choices
        for i in 0..<choices.count {
            textChoices.append(ORKTextChoice(text: choices[i], value: "\(i)" as NSCoding & NSCopying & NSObjectProtocol))
        }
        
        var answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        
        if(multiSelect){
            answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: textChoices)
        }
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        //let aStep = ORKAudioStep()
        
        step += [questionStep]
        
        return step
    }
    
    // Make the scale questions
    func makeScale(id: String, title: String, choices: [String]) -> [ORKStep] {
        var step = [ORKStep]()
        // The text to display can be separate from the value coded for each choice:
        var textChoices = [ORKTextChoice]()
        // Add each choices
        for i in 0..<choices.count {
            textChoices.append(ORKTextChoice(text: choices[i], value: "\(i)" as NSCoding & NSCopying & NSObjectProtocol))
        }
        
        //        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let answerFormat = ORKAnswerFormat.textScale(with: textChoices, defaultIndex: NSIntegerMax, vertical: false)
        
        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
        
        step += [questionStep]
        
        return step
    }
    
    // time, message, repeat
    func schedule(date:DateComponents, title:String, message:String, rep:Bool, id:String){
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message,
                                                                arguments: nil)
        let defaults = UserDefaults.standard
        
        // Ensure only 1 notification is saved.
        if(!defaults.bool(forKey: id)){
            defaults.set(true, forKey: "\(title)\(index)")
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: rep)
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            // Schedule the request.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    // from, to, until, timesPerDay, message
    func randomSchedule(from:Int, to:Int, until:Date, timesPerDay:Int, title: String, message: String){
        var date = Date()
        var index = 0
        let userCalendar = Calendar.current
        // If you use |until| without incrementing and <= for the loop, the code will only work
        // at the exact moment the survey is made, but if you create a cap the day after and
        // use < you should be safe, hence |untilCap|.
        let untilCap = userCalendar.date(byAdding: .day, value: 1, to: until)!
        while(date < untilCap) {
            for _ in 1...timesPerDay {
                var dateInfo = DateComponents()
                dateInfo.hour = (Int(arc4random_uniform(UInt32(to - from))) + from) % 24
                dateInfo.minute = Int(arc4random_uniform(60))
                // Doesnt actually support minutes yet.
                
                
                schedule(date: dateInfo, title: title, message: message, rep: false, id: "\(title)\(index)")
                index+=1
            }
            
            // Increment a day by user's calender unit for day.
            date = userCalendar.date(byAdding: .day, value: 1, to: date)!
        }
    }
    
    var otherSense: ORKTask {
        var step = [ORKStep]()
        
        let instruction = ORKInstructionStep(identifier: "instruction1")
        instruction.title = "Other Sensors"
        instruction.text = "Realize you have access to weather and location data as well. Location data will be taken if you add the weather module. Weather data is comprised of the temperature in degrees Fahrenheit and the current weather condition. "
        
        step += [instruction]
        
        return ORKOrderedTask(identifier: "Other Sensors", steps: step)
        
    }
}
