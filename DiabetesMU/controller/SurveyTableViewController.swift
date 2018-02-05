////
////  SurveyTableViewController.swift
////  DiabetesMU
////
////  Created by Yohanes Patrik Handrianto on 1/29/18.
////  Copyright © 2018 Yohanes Patrik Handrianto. All rights reserved.
////
//
import UIKit
import Firebase
import ResearchKit
import UserNotifications
import CoreLocation
//
//class SurveyTableViewController: UITableViewController, CLLocationManagerDelegate {
//
//    let manager = CLLocationManager()
//
//    var surveys = [SurveyObj]()
//    var surveysProt = [SurveyObj]()
//
//    let publicSection = 1
//    let privateSection = 0
//
//    let privateCode = 1
//    let publicCode = 2
//
//    var firstLoggin = false
//    private var notification: NSObjectProtocol?
//
//    var currentLocation:CLLocation?
//    var currentSpeed:CLLocationSpeed?
//
//    deinit {
//        if let notification = notification {
//            NotificationCenter.default.removeObserver(notification)
//        }
//    }
//
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        notification = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) {
//            [unowned self] notification in
//            NSLog("reinit lists after background")
//            self.surveys = [SurveyObj]()
//            self.surveysProt = [SurveyObj]()
//            self.getPublicData()
//            self.getPrivateData()
//            self.handleDeleteData()
//        }
//
//        // User permission for notifications.
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//            // Enable or disable features based on authorization.
//            let generalCategory = UNNotificationCategory(identifier: "GENERAL",
//                                                         actions: [],
//                                                         intentIdentifiers: [],
//                                                         options: .customDismissAction)
//
//            // Register the category.
//            let center = UNUserNotificationCenter.current()
//            center.setNotificationCategories([generalCategory])
//        }
//        if FIRAuth.auth()?.currentUser != nil {
//            // User is signed in.
//            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//            getPublicData()
//            getPrivateData()
//            handleDeleteData()
//        } else {
//            // No user is signed in.
//            self.performSegue(withIdentifier: "notLoggedInt", sender: self)
//        }
//
//        UIView.appearance(whenContainedInInstancesOf: [ORKTaskViewController.self]).tintColor = UIColor(netHex:0xFAC832)
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        //
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//        //
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        let location = locations[0]
//        currentLocation = location
//        currentSpeed = location.speed
//
//        //meters per second
//        print(location.speed)
//    }
//    @IBOutlet weak var killButton: UIBarButtonItem!
//    @IBAction func killNotif(_ sender: Any) {
//        //SurveyObj().unscheduleAllNotifications()
//        killButton.tintColor = UIColor.green
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setToolbarHidden(false, animated: false)
//        self.navigationController?.toolbar.barStyle = UIBarStyle.black
//        self.navigationController?.toolbar.tintColor = UIColor(netHex:0xFAC832)
//        self.navigationController?.toolbar.isTranslucent = true
//
//        if(firstLoggin) {
//            firstLoggin = false
//            if FIRAuth.auth()?.currentUser != nil {
//                // User is signed in.
//                getPublicData()
//                getPrivateData()
//                handleDeleteData()
//            } else {
//                // No user is signed in.
//                self.performSegue(withIdentifier: "notLoggedInt", sender: self)
//            }
//        }
//    }
//
//    @IBAction func logOut(_ sender: Any) {
//        do {
//            try FIRAuth.auth()?.signOut()
//
//            surveys = [SurveyObj]()
//            surveysProt = [SurveyObj]()
//
//            self.tableView.reloadData()
//            self.performSegue(withIdentifier: "notLoggedInt", sender: self)
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//
//    // MARK: - Database Methods
//
//    func getPublicData() {
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//        ref.child("blueprints").observe(FIRDataEventType.childAdded, with: { (snapshot) in
//            // warning: handle all child action events, like changed or removed
//            //            NSLog("access\(snapshot.hasChild("access"))")
//            //            NSLog("statues\(snapshot.hasChild("status"))")
//            if ((snapshot.hasChild("access") && snapshot.hasChild("status"))  &&
//                (snapshot.childSnapshot(forPath: "access").value as! Int == self.publicCode &&
//                    snapshot.childSnapshot(forPath: "status").value as! Int == self.publicCode)){
//                let survey = self.getSurveyData(snapshot: snapshot)
//                survey.buildSurv()
//
//                if(survey.takable.outputDirectory == nil){
//                    survey.takable.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    //let path = Bundle.main.path(forResource: snapshot.key, ofType: "png")
//                    //survey.takable.outputDirectory = NSURL.fileURL(withPath: path!)
//                }
//                self.surveys.append(survey)
//                self.tableView.reloadData()
//            }
//        })
//    }
//
//    func handleDeleteData() {
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//
//        ref.child("blueprints").observe(FIRDataEventType.childRemoved, with: { (snapshot) in
//            // warning: handle all child action events, like changed or removed
//            for (index, survey) in self.surveys.enumerated() {
//                if (survey.id == snapshot.key){
//                    self.surveys.remove(at: index)
//                }
//            }
//
//            for (index, survey) in self.surveysProt.enumerated() {
//                if (survey.id == snapshot.key){
//                    self.surveysProt.remove(at: index)
//                }
//            }
//            self.tableView.reloadData()
//        })
//    }
//
//    func getPrivateData() {
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//
//        ref.child("users/\(FIRAuth.auth()?.currentUser?.uid as! String)/taking").observe(FIRDataEventType.childAdded, with: { (snapshot) in
//            // Observe once to handle delete case.
//            ref.child("blueprints/\(snapshot.value as! String)").observeSingleEvent(of: .value , with: { (snapshot) in
//                // warning: handle all child action events, like changed or removed
//
//                if ((snapshot.hasChild("access") && snapshot.hasChild("status"))  &&
//                    (snapshot.childSnapshot(forPath: "access").value as! Int == self.privateCode &&
//                        snapshot.childSnapshot(forPath: "status").value as! Int == self.publicCode)){
//                    let survey = self.getSurveyData(snapshot: snapshot)
//                    survey.buildSurv()
//
//                    if(survey.takable.outputDirectory == nil){
//                        survey.takable.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    }
//                    self.surveysProt.append(survey)
//
//                    self.tableView.reloadData()
//                }
//            })
//        })
//    }
//
//    func getSurveyData(snapshot:FIRDataSnapshot)->SurveyObj{
//        let survey = SurveyObj()
//
//        survey.id = snapshot.key
//        if let name = snapshot.childSnapshot(forPath: "name").value as? String{
//            survey.name = name
//        }
//        if let username = snapshot.childSnapshot(forPath: "user").value as? String{
//            survey.username = username
//        }
//
//        if let snapshot = snapshot.childSnapshot(forPath: "survey").children.allObjects as? [FIRDataSnapshot]{
//            // Generate survey step by step.
//            for rest in snapshot {
//                let postDict = rest.value as? [String : AnyObject] ?? [:]
//
//                let step = StepObj()
//                var type = ""
//                if let typeO = postDict["type"] as? String{
//                    type = typeO
//                }
//
//                switch type {
//                case "MultipleChoice":
//                    let questionTitle = postDict["title"] as? String ?? ""
//                    let questions = postDict["choices"] as? [String] ?? ["ERROR a","ERROR b"]
//
//                    let archiver = NSKeyedArchiver()
//                    archiver.encode(questionTitle, forKey: "title")
//                    archiver.encode(questions, forKey: "questions")
//                    archiver.finishEncoding()
//                    step.title = archiver.encodedData.base64EncodedString()
//                    step.id = postDict["id"] as? String ?? ""
//                    step.type = type
//                    step.condit = postDict["conditionID"] as? String ?? ""
//                    step.on = postDict["on"] as? String ?? ""
//                    step.groupID = postDict["groupID"] as? String ?? ""
//                    NSLog("-\(questionTitle)")
//                    if let multiSelect = postDict["multiSelect"] as? Bool {
//                        step.multiSelect = multiSelect
//                        NSLog("-\(questionTitle) \(multiSelect)")
//                    }
//                    //
//                    step.conditionDefault = postDict["conditionDefault"] as? String ?? ""
//                    let tempConditions = postDict["conditions"] as? [AnyObject] ?? []
//                    for tempCondition in tempConditions{
//                        let condition = tempCondition as? [String : AnyObject] ?? [:]
//                        let conObj = conditionObj()
//                        conObj.trigger = condition["trigger"] as AnyObject
//                        conObj.toID = condition["toID"] as? String ?? ""
//                        step.conditions.append(conObj)
//                    }
//                    //
//
//                case "Scale":
//                    let questionTitle = postDict["title"] as? String ?? ""
//                    let choices = postDict["choices"] as? [String] ?? ["ERROR a","ERROR b"]
//
//                    let archiver = NSKeyedArchiver()
//                    archiver.encode(questionTitle, forKey: "title")
//                    archiver.encode(choices, forKey: "choices")
//                    archiver.finishEncoding()
//                    step.title = archiver.encodedData.base64EncodedString()
//                    step.id = postDict["id"] as? String ?? ""
//                    step.type = type
//                    step.condit = postDict["conditionID"] as? String ?? ""
//                    step.on = postDict["on"] as? String ?? ""
//                    step.groupID = postDict["groupID"] as? String ?? ""
//                    //
//                    step.conditionDefault = postDict["conditionDefault"] as? String ?? ""
//                    let tempConditions = postDict["conditions"] as? [AnyObject] ?? []
//                    for tempCondition in tempConditions{
//                        let condition = tempCondition as? [String : AnyObject] ?? [:]
//                        let conObj = conditionObj()
//                        conObj.trigger = condition["trigger"] as AnyObject
//                        conObj.toID = condition["toID"] as? String ?? ""
//                        step.conditions.append(conObj)
//                    }
//                    //
//
//                case "scheduledNotification":
//                    step.notifMessage = postDict["notifMessage"] as? String ?? "Take your survey!"
//                    step.repeatBool = postDict["notifRepeat"] as? Bool ?? false
//                    step.notifWhen = postDict["notifWhen"] as? String ?? ""
//                    step.title = "Notification"
//                    step.id = postDict["id"] as? String ?? ""
//                    step.type = type
//
//                case "randomNotification":
//                    step.notifMessage = postDict["notifMessage"] as? String ?? "Take your survey!"
//                    step.notifFrom = postDict["notifFrom"] as? String ?? ""
//                    step.notifTo = postDict["notifTo"] as? String ?? ""
//                    step.notifUntil = Int(postDict["notifUntil"] as? Int16 ?? 0)//postDict["notifUntil"] as? String ?? ""
//                    step.notifTimes = Int(postDict["notifTimes"] as? Int16 ?? 0)
//                    step.title = "Notification"
//                    step.id = postDict["id"] as? String ?? ""
//                    step.type = type
//
//                default:
//                    step.title = postDict["title"] as? String ?? ""
//                    step.id = postDict["id"] as? String ?? ""
//                    step.type = type
//                    step.condit = postDict["conditionID"] as? String ?? ""
//                    step.on = postDict["on"] as? String ?? ""
//                    step.groupID = postDict["groupID"] as? String ?? ""
//                    //
//                    step.conditionDefault = postDict["conditionDefault"] as? String ?? ""
//                    let tempConditions = postDict["conditions"] as? [AnyObject] ?? []
//                    for tempCondition in tempConditions{
//                        let condition = tempCondition as? [String : AnyObject] ?? [:]
//                        let conObj = conditionObj()
//                        conObj.trigger = condition["trigger"] as AnyObject
//                        conObj.toID = condition["toID"] as? String ?? ""
//                        step.conditions.append(conObj)
//                    }
//                    //
//                }
//
//                survey.questions.append(step)
//            }
//        }
//
//        if let snapshot = snapshot.childSnapshot(forPath: "group").children.allObjects as? [FIRDataSnapshot]{
//            // Generate survey step by step.
//            for rest in snapshot {
//                let group = groupObj()
//                group.groupID = rest.key
//                let postDict = rest.value as? [String : AnyObject] ?? [:]
//                group.groupCount = postDict["groupCount"] as? Int ?? 0
//                group.random = postDict["random"] as? Bool ?? false
//                group.position = postDict["position"] as? Int ?? 0
//
//                if(group.random){
//                    group.startTitle = postDict["startTitle"] as? String ?? "Random Start"
//                    group.endTitle = postDict["endTitle"] as? String ?? "Random End"
//                }
//
//                survey.groups.append(group)
//            }
//
//            survey.groups = survey.groups.sorted(by: {$0.position < $1.position})
//        }
//
//        return survey
//    }
//
//    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(indexPath.section == publicSection){
//            surveys[(indexPath as NSIndexPath).row].takable.delegate = self
//            present(surveys[(indexPath as NSIndexPath).row].takable, animated: true, completion: nil)
//        }
//        if(indexPath.section == privateSection){
//            surveysProt[(indexPath as NSIndexPath).row].takable.delegate = self
//            present(surveysProt[(indexPath as NSIndexPath).row].takable, animated: true, completion: nil)
//        }
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if(section == publicSection){
//            return "Public"
//        }
//        else if (section == privateSection){
//            return "Your Surveys"
//        }
//        return ""
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(section == publicSection){
//            return self.surveys.count
//        }
//        else if(section == privateSection){
//            return self.surveysProt.count
//        }
//
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("SurveysTableViewCell", owner: self, options: nil)?.first as! SurveysTableViewCell
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        if(indexPath.section == publicSection){
//            cell.Title?.text = self.surveys[indexPath.row].name
//            cell.userName?.text = ""//self.surveys[indexPath.row].username
//            if(self.surveys[indexPath.row].takeTime < 1){
//                cell.timeLable?.text = "<1 min"
//            }
//            else{
//                cell.timeLable?.text = "\(Int(self.surveys[indexPath.row].takeTime)) min"
//            }
//        }
//        else if (indexPath.section == privateSection){
//            cell.Title?.text = self.surveysProt[indexPath.row].name
//            cell.userName?.text = ""//self.surveysProt[indexPath.row].username
//            if(self.surveysProt[indexPath.row].takeTime < 1){
//                cell.timeLable?.text = "<1 min"
//            }
//            else{
//                cell.timeLable?.text = "\(Int(self.surveysProt[indexPath.row].takeTime)) min"
//            }
//        }
//
//        return cell
//    }
//
//    /*
//     // Override to support conditional editing of the table view.
//     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//     // Return false if you do not want the specified item to be editable.
//     return true
//     }
//     */
//
//    /*
//     // Override to support editing the table view.
//     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//     if editingStyle == .delete {
//     // Delete the row from the data source
//     tableView.deleteRows(at: [indexPath], with: .fade)
//     } else if editingStyle == .insert {
//     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     }
//     }
//     */
//
//    /*
//     // Override to support rearranging the table view.
//     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//     }
//     */
//
//    /*
//     // Override to support conditional rearranging of the table view.
//     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//     // Return false if you do not want the item to be re-orderable.
//     return true
//     }
//     */
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}
//
//extension SurveysTableViewController: ORKTaskViewControllerDelegate {
//    /**
//     Tells the delegate that the task has finished.
//
//     The task view controller calls this method when an unrecoverable error occurs,
//     when the user has canceled the task (with or without saving), or when the user
//     completes the last step in the task.
//
//     In most circumstances, the receiver should dismiss the task view controller
//     in response to this method, and may also need to collect and process the results
//     of the task.
//
//     @param taskViewController  The `ORKTaskViewController `instance that is returning the result.
//     @param reason              An `ORKTaskViewControllerFinishReason` value indicating how the user chose to complete the task.
//     @param error               If failure occurred, an `NSError` object indicating the reason for the failure. The value of this parameter is `nil` if `result` does not indicate failure.
//     */
//    // date time, scale
//    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//
//        //gets info
//        //data output vvv
//        let para:NSMutableDictionary = NSMutableDictionary()
//        let taskResult = taskViewController.result
//        let taskIdentifier = taskViewController.task!.identifier;
//
//        if(reason != ORKTaskViewControllerFinishReason.discarded){
//
//            //here is where you can develop new data output from the surveys
//            //DATA OUT DIR
//            for result in taskResult.results! {
//                let stepResult = result as! ORKStepResult
//                for result in stepResult.results! {
//                    if let questionResult = result as? ORKChoiceQuestionResult{
//                        if(questionResult.answer != nil){
//                            let answer = questionResult.answer! as! [String]
//                            para.setValue(answer.joined(separator: ","), forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKNumericQuestionResult{
//                        if(questionResult.answer != nil){
//                            let answer = questionResult.answer! as! NSDecimalNumber
//                            para.setValue(answer, forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKTextQuestionResult{
//                        if(questionResult.answer != nil){
//
//                            let answer = questionResult.answer! as! String
//                            para.setValue(answer, forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKTimeIntervalQuestionResult {
//                        if(questionResult.answer != nil){
//                            let answer = questionResult.intervalAnswer
//                            para.setValue(answer, forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKDateQuestionResult{
//                        if(questionResult.answer != nil){
//                            let answer = questionResult.dateAnswer!
//                            let dfo = DateFormatter()
//                            dfo.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                            para.setValue(dfo.string(from: answer), forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKTimeOfDayQuestionResult{
//                        if(questionResult.answer != nil){
//                            let answer = questionResult.dateComponentsAnswer
//                            let answerString = "\(answer!.hour!):\(answer!.minute!)"
//                            para.setValue(answerString, forKey: questionResult.identifier)
//                        }
//                    }
//                    if let questionResult = result as? ORKFileResult {
//                        //questionResult.fileURL
//                        let storage = FIRStorage.storage()
//                        let storageRef = storage.reference()
//
//                        // Create a reference to the file you want to upload
//                        let riversRef = storageRef.child("images/\(taskIdentifier)/\(questionResult.identifier).jpg")
//
//                        // Upload the file to the path "images/rivers.jpg"
//                        let uploadTask = riversRef.putFile(questionResult.fileURL!, metadata: nil) { metadata, error in
//                            if let error = error {
//                                // Uh-oh, an error occurred!
//                            } else {
//                                // Metadata contains file metadata such as size, content-type, and download URL.
//                                let downloadURL = metadata!.downloadURL()
//                                para.setValue(downloadURL, forKey: questionResult.identifier)
//                            }
//                        }
//                    }
//                    //                    if let filePath = self.surveys.last?.takable.outputDirectory?.path, let image = UIImage(contentsOfFile: filePath) {
//                    //                        NSLog("!!!!")
//                    //                        // /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles
//                    //                        // 2017-09-29 00:59:24.942125-0500
//                    //                    }
//                }
//            }
//
//            var ref: FIRDatabaseReference!
//            ref = FIRDatabase.database().reference()
//
//            let uid = FIRAuth.auth()?.currentUser?.uid
//            // let now = NSDate().timeIntervalSince1970
//            let now = Date()
//            let df = DateFormatter()
//            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let dateString = df.string(from: now)
//            var write = false
//
//            var i = 0
//            for survey in self.surveys {
//                if survey.id == taskResult.identifier{
//                    self.surveys.remove(at: i)
//                    //self.taskViewController.remove(at: i)
//                    write = true
//                    i-=1
//                }
//                i+=1
//            }
//            i=0
//            for survey in self.surveysProt {
//                if survey.id == taskResult.identifier{
//                    self.surveysProt.remove(at: i)
//                    write = true
//                    i-=1
//                }
//                i+=1
//            }
//            if(write){
//                ref.child("data").child(taskIdentifier).child("answers").childByAutoId().updateChildValues(["timeStamp":dateString, "surveyData":para, "userID":uid ?? ""])
//            }
//            self.tableView.reloadData()
//        }
//
//        taskViewController.dismiss(animated: true, completion: nil)
//    }
//}
//
//
