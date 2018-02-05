//import Foundation
//import CoreData
//import ResearchKit
//import UserNotifications
//
//struct law{
//    var id = ""
//    var rule:ORKPredicateStepNavigationRule!
//}
//
//// Empty conditionDefault string
//// set conditions, MUST also set conditionDefault
//
//class SurveyObj{
//    var name = ""
//    var id = "TAdefault"
//    var questions = [StepObj]()
//    var takeTime = 0.0
//    var username = ""
//    var takable:ORKTaskViewController
//    var notifications = [UNNotificationRequest]()
//    var groups = [groupObj]()
//    
//    init(){
//        var step = [ORKStep]()
//        let instructionStep = ORKInstructionStep(identifier: "ERROR")//create an instruction survey step
//        instructionStep.title = "ERROR Loading Survey"
//        step += [instructionStep]
//        let task = ORKNavigableOrderedTask(identifier: "ERROR", steps:step)
//        takable = ORKTaskViewController(task: task, taskRun: UUID())
//    }
//    
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
//    
//    func randomzeQuestions(questionArray:[StepObj])->[StepObj]{
//        var tempQ = questionArray
//        
//        for i in 0...questionArray.count-1 {
//            tempQ.swapAt(i, Int(arc4random_uniform(UInt32(questionArray.count - 1))))
//        }
//        
//        return tempQ
//    }
//    
//    //    rand{
//    //        0:
//    //        start: "id"
//    //        size:int
//    //        startTitle:""
//    //        endTitle:""
//    //    }
//    
//    func orderSurv(){
//        var finalOrganizedSurvey = [StepObj]()
//        for group in groups {
//            var groupStepArray = [StepObj]()
//            var j = 0
//            while(groupStepArray.count < group.groupCount && j < questions.count){//error check here
//                print("pppp\(j)")
//                if(group.groupID == questions[j].groupID){
//                    groupStepArray.append(questions[j])
//                }
//                j+=1
//            }
//            
//            if(group.random) {
//                groupStepArray = randomzeQuestions(questionArray: groupStepArray)
//                let endSlide = StepObj()
//                let startSlide = StepObj()
//                
//                endSlide.id = "\(group.groupID)^end"
//                startSlide.id = "\(group.groupID)^start"
//                
//                endSlide.title = group.endTitle
//                startSlide.title = group.startTitle
//                
//                endSlide.type = "textSlide"
//                startSlide.type = "textSlide"
//                
//                groupStepArray.insert(startSlide, at: 0)
//                groupStepArray.append(endSlide)
//            }
//            
//            finalOrganizedSurvey += groupStepArray
//        }
//        
//        if (groups.count > 0){
//            questions = finalOrganizedSurvey
//        }
//    }
//    
//    func buildSurv()->ORKTaskViewController{
//        var steps = [ORKStep]()
//        var laws = [law]()
//        
//        orderSurv()
//        
//        for question in questions {
//            if(question.type == "yesNo"){
//                steps += self.makeBool(id: question.id, title: question.title)
//                takeTime += 0.1
//            } else if(question.type == "textSlide"){
//                steps += self.makeTextSlide(id: question.id, title: question.title)
//                takeTime += 0.1
//            } else if(question.type == "textField"){
//                steps += self.makeTextField(id: question.id, title: question.title)
//                takeTime += 0.3
//            }
//            else if(question.type == "imgCapt"){
//                steps += self.makeImgCapt(id: question.id)
//                takeTime += 0.5
//            }
//            else if(question.type == "timeInt"){
//                steps += self.makeTimeInt(id: question.id, title: question.title)
//                takeTime += 0.4
//                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
//            }
//            else if(question.type == "timeOfDay"){
//                steps += self.makeTimeOfDay(id: question.id, title: question.title)
//                takeTime += 0.4
//                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
//            }
//            else if(question.type == "dateTime"){
//                steps += self.makeDateTime(id: question.id, title: question.title)
//                takeTime += 0.4
//                //steps += [ORKAudioStep(identifier: id+"ll9", duration: 5)]
//            } else if(question.type == "MultipleChoice") {
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
//            } else if(question.type == "BAC") {
//                steps += self.makeBAC(id: question.id)
//                takeTime += 1.5
//            } else if(question.type == "scheduledNotification") {
//                var dateInfo = DateComponents()
//                var fullNameArr = question.notifWhen.components(separatedBy: ":")
//                dateInfo.hour = Int(fullNameArr[0])
//                dateInfo.minute = Int(fullNameArr[1])
//                schedule(date: dateInfo, title: name, message: question.notifMessage, rep: question.repeatBool, id: question.id)
//            } else if(question.type == "randomNotification") {
//                //                let dateInfo = DateFormatter()
//                //                dateInfo.dateFormat = "MMMM d, Y"
//                //let until = dateInfo.date(from: question.notifUntil)
//                let until = question.notifUntil
//                var fullNameArr = question.notifFrom.components(separatedBy: ":")
//                let from = Int(fullNameArr[0])
//                fullNameArr = question.notifTo.components(separatedBy: ":")
//                let to = Int(fullNameArr[0])
//                randomSchedule(from: from!, to: to!, until: until, timesPerDay: question.notifTimes, title: name, message: question.notifMessage, id: question.id)
//            }
//            
//            //
//            if let law = conditionCreate(question: question){
//                laws.append(law)
//            }
//            //
//        }
//        
//        steps += self.makeTextSlide(id: "^EOS", title: "Thank you for taking this TigerAware survey!")
//        //steps += self.makeBool(id: "^EOS", title: "Can we collect your location?")
//        
//        let task = ORKNavigableOrderedTask(identifier: id, steps:steps)
//        //
//        for lawCondition in laws {
//            task.setNavigationRule(lawCondition.rule, forTriggerStepIdentifier: lawCondition.id)
//        }
//        //
//        
//        takable = ORKTaskViewController(task: task, taskRun: UUID())
//        return ORKTaskViewController(task: task, taskRun: UUID())
//        
//    }
//    
//    func conditionCreate(question:StepObj) -> law!{
//        let inptResultSelector = ORKResultSelector(stepIdentifier: question.id, resultIdentifier: question.id)
//        var predicates = [NSPredicate]()
//        var toIDs = [String]()
//        // Condition types being handled.
//        if(question.type == "yesNo") {
//            for condition in question.conditions {
//                predicates.append(ORKResultPredicate.predicateForChoiceQuestionResult(with: inptResultSelector, expectedAnswerValue: (condition.trigger as? String ?? "^ERROR") as NSCoding & NSCopying & NSObjectProtocol))
//                toIDs.append(condition.toID)
//            }
//        } else if(question.type == "textField") {
//            for condition in question.conditions{
//                predicates.append(ORKResultPredicate.predicateForTextQuestionResult(with: inptResultSelector, expectedString: (condition.trigger as? String ?? "^ERROR")))
//                toIDs.append(condition.toID)
//            }
//        } else if(question.type == "MultipleChoice") {
//            for condition in question.conditions{
//                predicates.append(ORKResultPredicate.predicateForChoiceQuestionResult(with: inptResultSelector, expectedAnswerValue: (condition.trigger as? String ?? "^ERROR") as NSCoding & NSCopying & NSObjectProtocol))
//                toIDs.append(condition.toID)
//            }
//        } else if(question.type == "Scale") {
//            for condition in question.conditions{
//                predicates.append(ORKResultPredicate.predicateForChoiceQuestionResult(with: inptResultSelector, expectedAnswerValue: (condition.trigger as? String ?? "^ERROR") as NSCoding & NSCopying & NSObjectProtocol))
//                toIDs.append(condition.toID)
//            }
//        } else if(question.type == "BAC") {
//            for condition in question.conditions{
//                // equal
//                predicates.append(ORKResultPredicate.predicateForNumericQuestionResult(with: inptResultSelector, minimumExpectedAnswerValue: condition.trigger as? Double ?? 1.01))
//                toIDs.append(condition.toID)
//            }
//        } else if(question.type == "textSlide") {
//            if(!question.conditionDefault.isEmpty) {
//                predicates.append(ORKResultPredicate.predicateForTextQuestionResult(with: inptResultSelector, expectedString: "bla"))
//                toIDs.append("")
//            }
//        }
//        
//        if (!predicates.isEmpty){
//            var law1 = law()
//            law1.rule = ORKPredicateStepNavigationRule(resultPredicates: predicates, destinationStepIdentifiers: toIDs, defaultStepIdentifier: question.conditionDefault, validateArrays: true)
//            law1.id = question.id
//            return law1
//        }
//        
//        return nil
//    }
//    
//    func makeBool(id: String, title:String)->[ORKStep]{
//        var step = [ORKStep]()
//        // The text to display can be separate from the value coded for each choice:
//        let textChoices = [
//            ORKTextChoice(text: "Yes", value: "Yes" as NSCoding & NSCopying & NSObjectProtocol),
//            ORKTextChoice(text: "No", value: "No" as NSCoding & NSCopying & NSObjectProtocol)
//        ]
//        
//        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        //let aStep = ORKAudioStep()
//        
//        //step += [questionStep]
//        step += [questionStep]
//        
//        return step
//        
//    }
//    
//    func makeBAC(id: String)->[ORKStep]{
//        var step = [ORKStep]()
//        
//        let questionStep = ORKBACStep(identifier: id)
//        
//        step += [questionStep]
//        
//        return step
//    }
//    
//    func makeTextSlide(id: String, title:String)->[ORKStep]{
//        var step = [ORKStep]()
//        // The text to display can be separate from the value coded for each choice:
//        let instructionStep = ORKInstructionStep(identifier: id)//create an instruction survey step
//        instructionStep.title = title
//        step += [instructionStep]
//        
//        return step
//        
//    }
//    
//    func makeTextField(id: String, title:String)->[ORKStep]{
//        var step = [ORKStep]()
//        // The text to display can be separate from the value coded for each choice:
//        
//        let answerFormat = ORKAnswerFormat.textAnswerFormat()
//        //let answerFormat = ORKAnswerFormat.decimalAnswerFormat(withUnit: "in")//ORKAnswerFormat.continuousScale(withMaximumValue: 100, minimumValue: 0, defaultValue: 50, maximumFractionDigits: 0, vertical: t, maximumValueDescription: "pain", minimumValueDescription: "feel good")//ORKAnswerFormat.decimalAnswerFormat(withUnit: "in")
//        
//        let textField = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        //textField.text = exampleDetailText
//        
//        step += [textField]
//        
//        return step
//    }
//    
//    func makeImgCapt(id: String)->[ORKStep]{
//        var step = [ORKStep]()
//        
//        let imageCaptureStep = ORKImageCaptureStep(identifier: id)
//        imageCaptureStep.isOptional = false
//        imageCaptureStep.accessibilityInstructions = NSLocalizedString("Your instructions for capturing the image", comment: "")
//        imageCaptureStep.accessibilityHint = NSLocalizedString("Captures the image visible in the preview", comment: "")
//        
//        imageCaptureStep.title = "hello"
//        
//        step += [imageCaptureStep]
//        
//        return step
//    }
//    
//    func makeTimeInt(id: String, title:String)->[ORKStep]{
//        let answerFormat = ORKAnswerFormat.timeIntervalAnswerFormat()
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        return [questionStep]
//    }
//    
//    func makeTimeOfDay(id: String, title:String)->[ORKStep]{
//        let answerFormat = ORKAnswerFormat.timeOfDayAnswerFormat()
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        return [questionStep]
//    }
//    
//    func makeDateTime(id: String, title:String)->[ORKStep]{
//        let answerFormat = ORKAnswerFormat.dateTime()
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        return [questionStep]
//    }
//    
//    // Make the multiple choice question
//    func makeMultipleChlice(id: String, title: String, choices: [String], multiSelect: Bool) -> [ORKStep] {
//        var step = [ORKStep]()
//        // The text to display can be separate from the value coded for each choice:
//        var textChoices = [ORKTextChoice]()
//        // Add each choices
//        for i in 0..<choices.count {
//            textChoices.append(ORKTextChoice(text: choices[i], value: "\(i)" as NSCoding & NSCopying & NSObjectProtocol))
//        }
//        
//        var answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//        
//        if(multiSelect){
//            answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: textChoices)
//        }
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        //let aStep = ORKAudioStep()
//        
//        step += [questionStep]
//        
//        return step
//    }
//    
//    // Make the scale questions
//    func makeScale(id: String, title: String, choices: [String]) -> [ORKStep] {
//        var step = [ORKStep]()
//        // The text to display can be separate from the value coded for each choice:
//        var textChoices = [ORKTextChoice]()
//        // Add each choices
//        for i in 0..<choices.count {
//            textChoices.append(ORKTextChoice(text: choices[i], value: "\(i)" as NSCoding & NSCopying & NSObjectProtocol))
//        }
//        
//        //        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
//        let answerFormat = ORKAnswerFormat.textScale(with: textChoices, defaultIndex: NSIntegerMax, vertical: false)
//        
//        let questionStep = ORKQuestionStep(identifier: id, title: title, answer: answerFormat)
//        
//        step += [questionStep]
//        
//        return step
//    }
//    
//    // remove all notifications/ remove notifications indefinitely
//    func unscheduleAllNotifications(){
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        center.removeAllDeliveredNotifications()
//    }
//    
//    func cleanNotif(){
//        let center = UNUserNotificationCenter.current()
//        center.removeAllDeliveredNotifications()
//    }
//    
//    func removeFutureNotifications(){
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//    }
//    
//    func removeFutureNotifsWIDs(ids:[String]){
//        let center = UNUserNotificationCenter.current()
//        center.removePendingNotificationRequests(withIdentifiers: ids)
//    }
//    
//    // delete a notification when it is deleted
//    func removeDeletedNotifications(){
//        
//    }
//    
//    // time, message, repeat
//    func schedule(date:DateComponents, title:String, message:String, rep:Bool, id:String){
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: message,
//                                                                arguments: nil)
//        let defaults = UserDefaults.standard
//        NSLog("---o \(title)+\(id)")
//        
//        let c = UNUserNotificationCenter.current()
//        ////        c.removeAllDeliveredNotifications()
//        ////        c.removeAllPendingNotificationRequests()
//        //        //c.removePendingNotificationRequests(withIdentifiers: <#T##[String]#>)
//        //
//        //        c.getDeliveredNotifications(){ (nots: [UNNotification]) in
//        //            for notification in nots {
//        //                print("z\(notification.date)")
//        //            }
//        //            //print("y")
//        //        }
//        //
//        c.getPendingNotificationRequests(){ (nots: [UNNotificationRequest]) in
//            for notification in nots {
//                let n = notification.trigger as! UNCalendarNotificationTrigger!
//                print("------Q \(n?.dateComponents.hour ?? 0):\(n?.dateComponents.minute ?? 0) \(notification.identifier) \(notification.content.title)")
//            }
//        }
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: rep)
//        
//        // Create the request object.
//        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//        
//        notifications.append(request)
//        
//        // Ensure only 1 notification is saved.
//        if(!defaults.bool(forKey: id)){
//            //defaults.set(true, forKey: "\(title)\(index)")
//            defaults.set(true, forKey: id)
//            NSLog("mmmm")
//            
//            //            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: rep)
//            //
//            //            // Create the request object.
//            //            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//            
//            // Schedule the request.
//            let center = UNUserNotificationCenter.current()
//            //            center.getDeliveredNotifications(){ (nots: [UNNotification]) in
//            //                print("y")
//            //            }
//            //            center.getDeliveredNotifications(completionHandler: <#T##([UNNotification]) -> Void#>)
//            //            center.add(<#T##request: UNNotificationRequest##UNNotificationRequest#>, withCompletionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
//            //            center.getPendingNotificationRequests(completionHandler: <#T##([UNNotificationRequest]) -> Void#>)
//            center.add(request) { (error : Error?) in
//                if let theError = error {
//                    print(theError.localizedDescription)
//                }
//            }
//        }
//    }
//    
//    //    // from, to, until, timesPerDay, message
//    //    func randomSchedule(from:Int, to:Int, until:Date, timesPerDay:Int, title: String, message: String, id:String){
//    //        var date = Date()
//    //        var index = 0
//    //        let userCalendar = Calendar.current
//    //        // If you use |until| without incrementing and <= for the loop, the code will only work
//    //        // at the exact moment the survey is made, but if you create a cap the day after and
//    //        // use < you should be safe, hence |untilCap|.
//    //        let untilCap = userCalendar.date(byAdding: .day, value: 1, to: until)!
//    //        while(date < untilCap) {
//    //            for _ in 1...timesPerDay {
//    //                    var dateInfo = DateComponents()
//    //                    dateInfo.hour = (Int(arc4random_uniform(UInt32(to - from))) + from) % 24
//    //                    dateInfo.minute = Int(arc4random_uniform(60))
//    //                    // Doesnt actually support minutes yet.
//    //
//    //                    schedule(date: dateInfo, title: title, message: message, rep: false, id: "\(id)\(index)")
//    //                    index+=1
//    //            }
//    //
//    //            // Increment a day by user's calender unit for day.
//    //            date = userCalendar.date(byAdding: .day, value: 1, to: date)!
//    //        }
//    //    }
//    
//    // from, to, until, timesPerDay, message
//    func randomSchedule(from:Int, to:Int, until:Int, timesPerDay:Int, title: String, message: String, id:String){
//        var date = Date()
//        var index = 0
//        let userCalendar = Calendar.current
//        // If you use |until| without incrementing and <= for the loop, the code will only work
//        // at the exact moment the survey is made, but if you create a cap the day after and
//        // use < you should be safe, hence |untilCap|.
//        let untilCap = userCalendar.date(byAdding: .day, value: until, to: date)!
//        while(date < untilCap) {
//            NSLog("**notif**\(untilCap)")
//            for _ in 1...timesPerDay {
//                var dateInfo = DateComponents()
//                let calender = NSCalendar.current
//                let month = calender.component(.month, from: date)
//                let day = calender.component(.day, from: date)
//                dateInfo.day = day
//                dateInfo.month = month
//                dateInfo.hour = (Int(arc4random_uniform(UInt32(to - from))) + from) % 24
//                dateInfo.minute = Int(arc4random_uniform(60))
//                
//                NSLog("rand: \(dateInfo.month)+\(dateInfo.day) \(dateInfo.hour):\(dateInfo.minute)")
//                // Doesnt actually support minutes yet.
//                
//                schedule(date: dateInfo, title: title, message: message, rep: false, id: "\(id)\(index)")
//                index+=1
//            }
//            
//            // Increment a day by user's calender unit for day.
//            date = userCalendar.date(byAdding: .day, value: 1, to: date)!
//        }
//    }
//    
//    var otherSense: ORKTask {
//        var step = [ORKStep]()
//        
//        let instruction = ORKInstructionStep(identifier: "instruction1")
//        instruction.title = "Other Sensors"
//        instruction.text = "Realize you have access to weather and location data as well. Location data will be taken if you add the weather module. Weather data is comprised of the temperature in degrees Fahrenheit and the current weather condition. "
//        
//        step += [instruction]
//        
//        return ORKOrderedTask(identifier: "Other Sensors", steps: step)
//        
//    }
//}
//
//
