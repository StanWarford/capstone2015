//
//  SectionsViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/18/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData

class SectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
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
    
    var sections = [ClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseOfInterest
        populateSections()
        sectionsList.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func populateSections() {
        sections = []
        var sectionDict = classDict![deptOfInterest!][courseOfInterest!]
        var sectionKeys = sectionDict.dictionary!.keys
        for sectionKey in sectionKeys {
            var name = courseOfInterest! + "." + sectionKey
            var course = sectionDict[sectionKey]["name"].string
            var status = sectionDict[sectionKey]["status"].string
            var professor = sectionDict[sectionKey]["professor"].string
            var room = sectionDict[sectionKey]["room"].string
            self.sections.append(ClassModel(name: name, course: course!, status: status!, professor: professor!, room: room!))
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SectionsTableViewCell = tableView.dequeueReusableCellWithIdentifier("SectionsCell") as SectionsTableViewCell
        // create cell
        let classFollowing = sections[indexPath.row]
        cell.setCell(classFollowing.name, courseNumber: classFollowing.course, status: classFollowing.status, professor: classFollowing.professor, room: classFollowing.room)
        if (classFollowing.status == "Open"){
            cell.status.textColor = alizarinRed
        } else {
            cell.status.textColor = emeraldGreen
        }
        cell.deptKey = deptOfInterest
        cell.courseKey = courseOfInterest
        //cell.sectionKey = classFollowing["subject"].string! // 02
        
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
