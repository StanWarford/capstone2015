//
//  SectionsViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/18/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData

//A Controller that populates and formats the SectionsView
class SectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    //Needed to access Core Data so that the user can follow a class from the SectionView
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
        }()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var sectionsList: UITableView!
    
    @IBAction func swipeBack(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // Not really doing anything at the moment
    @IBAction func followClassGeneric(sender: UIButton) {
            var alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Follow", style: .Default, handler: { action in
                
            }))
    }

// Extended Height functionality (Disabled)
    
//    var extendedHeight: NSIndexPath?
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if (extendedHeight == indexPath) {
//            extendedHeight = nil
//        } else {
//            extendedHeight = indexPath
//        }
//        sectionsList.beginUpdates()
//        sectionsList.endUpdates()
//    }
    
    
    //SearchTableViewCells are set to a fixed height of 132 --> displaying all
    //information relevant to the course
    //Uncommenting code below "Extended Height.." and "return 68" results in
    //a SearchTableViewCell height of 68 and a SearchTableViewCell height of
    //132 if said cell is tapped. (Cell Expansion to view more information)
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if (extendedHeight == indexPath) {
            return 132
//        }
//        return 68
    }
    
    var sections = [ClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseOfInterest
        populateSections()
        sectionsList.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //Navigates through classDict (JSON Dictionary of classes) using the user-selected department and user-selected course as keys
    //Populates Model, sections
    func populateSections() {
        sections = []
        if let deptDict = classDict?[deptOfInterest!].dictionary! {
            if let sectionDict = deptDict[courseOfInterest!] {
                var sectionKeys = sectionDict.dictionary!.keys
                for sectionKey in sectionKeys {
                    var classOfInterest = ClassModel()
                    classOfInterest.name = sectionDict[sectionKey]["name"].string
                    classOfInterest.dept = sectionDict[sectionKey]["department"].string
                    classOfInterest.course = sectionDict[sectionKey]["section"].string
                    classOfInterest.professor = sectionDict[sectionKey]["professor"].string
                    classOfInterest.room = sectionDict[sectionKey]["room"].string
                    classOfInterest.section = sectionDict[sectionKey]["subject"].string
                    classOfInterest.status = sectionDict[sectionKey]["status"].string
                    classOfInterest.time = sectionDict[sectionKey]["meeting"].string
                    self.sections.append(classOfInterest)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //Creates and Formats SectionsTableViewCells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SectionsTableViewCell = tableView.dequeueReusableCellWithIdentifier("SectionsCell") as! SectionsTableViewCell
        // create cell
        let classFollowing = sections[indexPath.row]
        
        cell.setCell(classFollowing.name,
            courseNumber: classFollowing.course,
            status: classFollowing.status,
            professor: classFollowing.professor,
            room: classFollowing.room,
            time: classFollowing.time)
        
        if (classFollowing.status == "Open"){
            cell.status.textColor = pepperdineOrange
        } else {
            cell.status.textColor = pepperdineGray
        }
        
        cell.deptKey = deptOfInterest
        cell.courseKey = courseOfInterest
        cell.sectionKey = split(classFollowing.course) {$0 == "."} [1]
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
