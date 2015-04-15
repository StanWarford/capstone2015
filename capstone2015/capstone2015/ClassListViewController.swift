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

var classes = [ClassModel]()

class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func changeColor(sender: UIButton) {
        //sender.backgroundColor = UIColor.orangeColor()
        //sender.titleColorForState(UIControlState.Normal) = UIColor.whiteColor().CGColor
        //sender.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var addNewClassButton: UIButton!
    
    @IBOutlet weak var statusBar: UIView!
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
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
    @IBAction func unfollow(sender: UIButton) {
        var alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Unfollow", style: .Default, handler: { action in
            var row = sender.tag
            classes.removeAtIndex(row)
            // remove the deleted item from the model
            let fetchRequest = NSFetchRequest(entityName: "ClassEntity")
            if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ClassEntity]{
                self.managedObjectContext!.deleteObject(fetchResults[row] as NSManagedObject)
            }
            self.managedObjectContext!.save(nil)
            // remove the deleted item from the `UITableView`
            var indexPath = NSIndexPath(forRow: row, inSection: 0)
            self.classList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClassListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClassListCell") as ClassListTableViewCell
        // create cell
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
    
    func populateClassList(){
        
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
