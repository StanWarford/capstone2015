//
//  CalendarViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/22/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

let pepperdineBlue = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)

//A Controller that populates and formats the CalendarView
class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var statusBar: UIView!
    
    @IBOutlet weak var titleBar: UINavigationItem!
    //Additional attributes needed to get the squares of the CalendarView to touch (i.e. no space in between blocks horizontally and vertically)
    var calendarView : UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    //A Model representation of the CalendarView
    var model = [[CalendarInfo?]](count: 30, repeatedValue: [CalendarInfo?](count: 6, repeatedValue: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBar.titleView = UIImageView(image: UIImage(named: "scriptLogo"))
        statusBar.backgroundColor = pepperdineBlue
    }
    
    override func viewWillAppear(animated: Bool) {
        configureCalendarView()
        
        // Convert classes to calendar units
        parseClasses()
        
        // Reset Calendar View
        calendarView!.reloadData()
    }
    
    // Programmatically create and configure Calendar View
    func configureCalendarView(){
        
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout = CustomCollectionViewLayout()
        calendarView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        calendarView!.dataSource = self
        calendarView!.delegate = self
        calendarView!.registerNib(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        calendarView!.backgroundColor = UIColor.whiteColor()
        calendarView!.preservesSuperviewLayoutMargins = false
        self.view.addSubview(calendarView!)
        calendarView?.bounces = false
    
        // Set auto-layout constraints for calendarView
        calendarView!.setTranslatesAutoresizingMaskIntoConstraints(false)

        let leftConstraint = NSLayoutConstraint(item: calendarView!,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0.0)
        self.view.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: calendarView!,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0.0)
        self.view.addConstraint(rightConstraint)
        
        //let top = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? CGFloat(40.0) : CGFloat(64.0)
        let topConstraint = NSLayoutConstraint(item: calendarView!,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.titleBar.titleView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)
        self.view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: calendarView!,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)
        self.view.addConstraint(bottomConstraint)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        configureCalendarView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //Populates and Formats CalendarViewCells using the above attribute "model" as the Model
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CalendarCollectionViewCell = calendarView!.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        if let classFollowing = model[indexPath.section][indexPath.row]{
            cell.setCell(classFollowing.text, color: classFollowing.color!)
            cell.layer.borderWidth = 0.0
        } else {
            cell.setCell("",color: nil)
            cell.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor//pepperdineBlue.CGColor
            cell.layer.borderWidth = 0.6
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = pepperdineLightGray
            } else {
                cell.backgroundColor = UIColor.whiteColor()
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[0].count // Number of columns
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return model.count // Number of rows
    }
    
    // Bryan's time-parsing functions
    
    var mapping : [String : Int] = ["Mo" : 1, "Tu" : 2, "We" : 3, "Th" : 4, "Fr" : 5]
    
    //Maps day and time information for each class the User is following
    //These mappings are needed to accurately populate the Model, model, which in turn, accurately populates the CalendarView
    func parseClasses(){
        model = [[CalendarInfo?]](count: 30, repeatedValue: [CalendarInfo?](count: 6, repeatedValue: nil))
        
        model[0][1] = CalendarInfo(text: "Monday", color: pepperdineBlue)
        model[0][2] = CalendarInfo(text: "Tuesday", color: pepperdineBlue)
        model[0][3] = CalendarInfo(text: "Wednesday", color: pepperdineBlue)
        model[0][4] = CalendarInfo(text: "Thursday", color: pepperdineBlue)
        model[0][5] = CalendarInfo(text: "Friday", color: pepperdineBlue)
        model[0][0] = CalendarInfo(text: "Time", color: pepperdineBlue)
        model[1][0] = CalendarInfo(text: "07:30AM", color: pepperdineBlue)
        
        var start = "7:30AM"
        
        for (var k = 2; k < model.count; k++){
            start = addThirtyMinutes(start)
            model[k][0] = CalendarInfo(text: start, color: pepperdineBlue) //first time is 8AM
        }
        
        for c in classes {
            if (c.time != "TBA") {
                var meetingTime = split(c.time) {$0 == " "}
                var days = mapDays(meetingTime[0])
                var time = mapTimes(meetingTime[1], end: meetingTime[3])
                populateCalModel(days, times: time, classModel: c)
            }
        }
    }
    
    //Updates the calendar Model, model, with class information for each class the User is following
    func populateCalModel(days: [Int], times: [Int], classModel: ClassModel) {
        
        for (var j = 0; j < days.count; j++){
            for(var i = 0; i < times[1]; i++){
                var startPoint = times[0]
                if(i == 0){
                    model[startPoint][days[j]] = CalendarInfo(text: classModel.name, color: UIColor.orangeColor())
                } else if (i == 1){
                    model[startPoint + i][days[j]] = CalendarInfo(text: classModel.time, color: UIColor.orangeColor())
                } else {
                    model[startPoint+i][days[j]] = CalendarInfo(color: UIColor.orangeColor())
                }
            }
        }
    }
    
    //Returns an array of strings that match the regex pattern (Similar to JavaScripts regex.match function)
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        let regex = NSRegularExpression(pattern: regex,
            options: nil, error: nil)!
        let nsString = text as NSString
        let results = regex.matchesInString(nsString as String,
            options: nil, range: NSMakeRange(0, nsString.length))
            as! [NSTextCheckingResult]
        return map(results) { nsString.substringWithRange($0.range)}
    }
    
    //Converts meeting day information to mappings that are used by the Model. TuFr ==> [1,4]
    func mapDays(days: String!) -> [Int]{
        
        var arrayOfDays = matchesForRegexInText(".{1,2}", text: days)
        var mappedDays : [Int] = []
        var index: Int
        
        for (index = 0; index < arrayOfDays.count; index++){
            var intDay = mapping[arrayOfDays[index]]
            mappedDays.append(intDay!)
        }
        
        return mappedDays //TuFr ==> [1,4]
    }
    
    //Converts start time information to mappings that are used by the Model and also counts the number of 30 minute segments the class occupies 
        //12:00PM, 1:50PM ==> [8,4] (noon == 8 on the Model w/ 4-30 min segs)
    func mapTimes(start: String!, end: String!) -> [Int] { //[startOnGrid, #segs]
        
        var startTime = matchesForRegexInText("[0-9]{2}", text: start) //[12,00]
        var startTimeOfDay = matchesForRegexInText("[A-Z]{2}", text: start)
        var endTime = matchesForRegexInText("[0-9]{2}", text: end)
        var endTimeOfDay = matchesForRegexInText("[A-Z]{2}", text: end)
        var mappedTimes : [Int] = []
        var segments = 0
        
        var startHour = startTime[0].toInt()
        var startMin = startTime[1].toInt()
        
        var endHour = endTime[0].toInt()
        var endMin = endTime[1].toInt()
        
        
        if(startHour != 12 && startTimeOfDay[0] == "PM"){
            startHour! += 12
        }
        
        if(endHour != 12 && endTimeOfDay[0] == "PM"){
            endHour! += 12
        }
        
        var hours = abs(startHour! - endHour!)
        var mins = abs(startMin! - endMin!)
        
        segments += hours * 2
        
        if(mins > 30){ //round 50 minutes up
            segments += 2
            hours += 1
            mins = 0
        } else if(mins == 30){
            segments += 1
        }
        
        var gridTime = timeToGrid(startHour!)
        mappedTimes.append(gridTime)
        mappedTimes.append(segments)
        
        return mappedTimes //12:00PM, 01:50PM ==> [8,4] [Noon, 4-30 mins]
    }
    
    //Converts times to 30 min blocks
    func timeToGrid(startTime: Int) -> Int{
        var gridTime = startTime - 7
        gridTime *= 2 //30 min blocks
        return gridTime
    }
    
    //Automatically populates the first column of the CalendarView with times, each separated by 30 minutes (i.e. 7:30, 8:00, ...)
    func addThirtyMinutes(time: String) -> String {
        
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        inFormatter.dateFormat = "hh:mma"
        
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"
        
        var stringToDate = inFormatter.dateFromString(time)!
        var addThirtyMinutes = stringToDate.dateByAddingTimeInterval(1800)
        var returnTime = outFormatter.stringFromDate(addThirtyMinutes)
        
        return returnTime
    }
}
