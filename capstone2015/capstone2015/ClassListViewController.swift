//
//  ClassListViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 1/29/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

//A Model used by ClassListViewController to create ClassListView
var classes = [ClassModel]()

//A Controller that populates and formats ClassListView (the courses a User is following)
class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func changeColor(sender: UIButton) {
        //sender.backgroundColor = UIColor.orangeColor()
        //sender.titleColorForState(UIControlState.Normal) = UIColor.whiteColor().CGColor
        //sender.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var addNewClassButton: UIButton!
    
    //Extracts class-following data from Core Data
    @IBOutlet weak var statusBar: UIView!
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    @IBOutlet weak var classList: UITableView!
    
    var increasedHeight: NSIndexPath?
    var cellToDelete: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewClassButton.layer.borderWidth = 1.35
        addNewClassButton.layer.borderColor = UIColor.orangeColor().CGColor
        addNewClassButton.layer.cornerRadius = 5.0
        
        var testObject = PFObject(className:"TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock(nil)
        
        titleBar.titleView = UIImageView(image: UIImage(named: "scriptLogo"))
        statusBar.backgroundColor = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)
        self.tabBarController?.tabBar.tintColor = UIColor.orangeColor()
        self.populateClassList()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    @IBAction func touchDown(sender: UIButton) {
        sender.backgroundColor = pepperdineGray
        sender.setTitleColor(pepperdineLightGray, forState: .Normal)
    }

    @IBAction func touchDrag(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        sender.setTitleColor(pepperdineGray, forState: .Normal)
    }
    
    
    @IBAction func unfollow(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        sender.setTitleColor(pepperdineGray, forState: .Normal)
        var alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
           
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Unfollow", style: .Default, handler: { action in
            var row = sender.tag
            classes.removeAtIndex(row)
            // remove the deleted item from the model & Core Data
            let fetchRequest = NSFetchRequest(entityName: "ClassEntity")
            if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ClassEntity]{
                self.managedObjectContext!.deleteObject(fetchResults[row] as NSManagedObject)
            }
            self.managedObjectContext!.save(nil)
            // remove the deleted item from the `UITableView`
            var indexPath = NSIndexPath(forRow: row, inSection: 0)
            self.classList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.populateClassList()
            self.classList.beginUpdates()
            self.classList.endUpdates()
        }))
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.cellToDelete == indexPath){
            self.cellToDelete = nil
            classes.removeAtIndex(indexPath.row)
            // remove the deleted item from the model
            let fetchRequest = NSFetchRequest(entityName: "ClassEntity")
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ClassEntity]{
                self.managedObjectContext!.deleteObject(fetchResults[indexPath.row] as NSManagedObject)
            }
            self.managedObjectContext!.save(nil)
            // remove the deleted item from the `UITableView`
            self.classList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.increasedHeight = nil
        }
        else if (self.increasedHeight == indexPath){
            self.increasedHeight = nil
        } else {
            self.increasedHeight = indexPath
        }
        classList.beginUpdates()
        classList.endUpdates()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.increasedHeight == indexPath){
            return 132.0
        }
        return 68.0
    }
    
    //Creates ClassListTableViewCells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClassListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClassListCell") as! ClassListTableViewCell
        let classFollowing = classes[indexPath.row]
        cell.setCell(classFollowing.course,
            course: classFollowing.name,
            status: classFollowing.status.uppercaseString,
            time: classFollowing.time,
            professor: classFollowing.professor,
            room: classFollowing.room)
        if (classFollowing.status == "Open"){
            cell.status.textColor = UIColor.orangeColor()
        } else {
            cell.status.textColor = UIColor.grayColor()
        }
        cell.followButton.tag = indexPath.row
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    //Populates the Model, classes, based on classes being followed in Core Data
    func populateClassList(){
        if (classDict != nil) {
        
        let fetchRequest2 = NSFetchRequest(entityName: "ClassEntity")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest2, error: nil) as? [ClassEntity]{
            classes = []
            
            for (var i = 0; i < fetchResults.count; i++){
                var entity = fetchResults[i]
                var classToAdd: JSON! = classDict![entity.deptKey][entity.courseKey][entity.sectionKey]
                var classFollowing = ClassModel()
                classFollowing.name = classToAdd["name"].string!
                classFollowing.dept = classToAdd["department"].string!
                classFollowing.course = classToAdd["section"].string!
                classFollowing.professor = classToAdd["professor"].string!
                classFollowing.room = classToAdd["room"].string!
                classFollowing.section = classToAdd["subject"].string!
                classFollowing.status = classToAdd["status"].string!
                classFollowing.time = classToAdd["meeting"].string!
                classes.append(classFollowing)
            }
        }
        self.classList.reloadData()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        self.populateClassList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
