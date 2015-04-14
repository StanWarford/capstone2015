//
//  CalendarViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/22/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var statusBar: UIView!
    
    @IBOutlet weak var calendarView: UICollectionView!
    
    var model = [[CalendarInfo?]](count: 28, repeatedValue: [CalendarInfo?](count: 5, repeatedValue: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar.backgroundColor = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)
        parseClasses()
    }
    
    override func viewWillAppear(animated: Bool) {
        parseClasses()
        calendarView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CalendarCollectionViewCell = calendarView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as CalendarCollectionViewCell
        if let classFollowing = model[indexPath.section][indexPath.row]{
            cell.setCell(classFollowing.text, color: classFollowing.color!)
        } else {
            cell.setCell("",color: nil)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[0].count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return model.count // #rows
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Bryan's functions
    
    var mapping : [String : Int] = ["Mo" : 1, "Tu" : 2, "We" : 3, "Th" : 4, "Fr" : 5]
    
    func parseClasses(){
        model = [[CalendarInfo?]](count: 29, repeatedValue: [CalendarInfo?](count: 6, repeatedValue: nil))
        for c in classes {
            if (c.time != "TBA") {
                var meetingTime = split(c.time) {$0 == " "}
                var days = mapDays(meetingTime[0])
                var time = mapTimes(meetingTime[1], end: meetingTime[3])
                populateCalModel(days, times: time, className: c.course)
            }
        }
    }
    
    func populateCalModel(days: [Int], times: [Int], className: String) {
        
        model[0][1] = CalendarInfo(text: "Mon", color: UIColor.blueColor())
        model[0][2] = CalendarInfo(text: "Tues", color: UIColor.blueColor())
        model[0][3] = CalendarInfo(text: "Wed", color: UIColor.blueColor())
        model[0][4] = CalendarInfo(text: "Thurs", color: UIColor.blueColor())
        model[0][5] = CalendarInfo(text: "Fri", color: UIColor.blueColor())
        
        var start = "7:30AM"
        
        for (var k = 2; k < model.count; k++){
            start = addThirtyMinutes(start)
            model[k][0] = CalendarInfo(text: start, color: UIColor.blueColor()) //first time is 8AM
        }
        
        for (var j = 0; j < days.count; j++){
            for(var i = 0; i < times[1]; i++){
                var startPoint = times[0]
                if(i == 0){
                    model[startPoint][days[j]] = CalendarInfo(text: className, color: UIColor.orangeColor())
                } else {
                    model[startPoint+i][days[j]] = CalendarInfo(color: UIColor.orangeColor())
                }
            }
        }
    }

    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        let regex = NSRegularExpression(pattern: regex,
            options: nil, error: nil)!
        let nsString = text as NSString
        let results = regex.matchesInString(nsString,
            options: nil, range: NSMakeRange(0, nsString.length))
            as [NSTextCheckingResult]
        return map(results) { nsString.substringWithRange($0.range)}
    }
    
    func mapDays(days: String!) -> [Int]{ //Ie take in array[0] == "TuFr"
        
        var arrayOfDays = matchesForRegexInText(".{1,2}", text: days)
        var mappedDays : [Int] = []
        var index: Int
        
        for (index = 0; index < arrayOfDays.count; index++){
            var intDay = mapping[arrayOfDays[index]]
            mappedDays.append(intDay!)
        }
        
        return mappedDays //TuFr ==> [1,4]
        
    }
    
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
    
    func timeToGrid(startTime: Int) -> Int{
        var gridTime = startTime - 7
        gridTime *= 2 //30 min blocks
        return gridTime
    }

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
