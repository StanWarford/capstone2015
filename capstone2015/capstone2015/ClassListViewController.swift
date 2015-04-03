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

class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        classList.setEditing(!classList.editing, animated: true)
        sender.title = classList.editing ? "Done" : "Edit"
    }
    
    @IBOutlet weak var classList: UITableView!
    
    var classes = [ClassModel]()
    var increasedHeights = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Unfollow"
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (contains(increasedHeights, indexPath)){
            if let index = find(increasedHeights, indexPath){
                increasedHeights.removeAtIndex(index)
            }
        } else {
            increasedHeights.append(indexPath)
        }
        classList.beginUpdates()
        classList.endUpdates()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (contains(increasedHeights, indexPath)){
            return 150.0
        }
        return 77.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClassListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClassListCell") as ClassListTableViewCell
        // create cell
        let classFollowing = classes[indexPath.row]
        cell.setCell(classFollowing.course, course: classFollowing.name, status: classFollowing.status.uppercaseString + " ●")
        if (classFollowing.status == "Open"){
            cell.status.textColor = UIColor.orangeColor()
        } else {
            cell.status.textColor = UIColor.grayColor()
        }
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete){
//            classes.removeAtIndex(indexPath.row) // To-do: Delete from core data instead
//            // remove the deleted item from the model
//            let fetchRequest = NSFetchRequest(entityName: "Class")
//            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Class]{
//                self.managedObjectContext!.deleteObject(fetchResults[indexPath.row] as NSManagedObject)
//            }
//            self.managedObjectContext!.save(nil)
//            // remove the deleted item from the `UITableView`
//            self.classList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
    }
    
    func populateClassList(){
        let fetchRequest = NSFetchRequest(entityName: "Class")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Class]{
            classes = []
            for (var i = 0; i < fetchResults.count; i++){
                var classFollowing = ClassModel(name: fetchResults[i].name, course: fetchResults[i].course, status: fetchResults[i].status, professor: fetchResults[i].professor, room: fetchResults[i].room)
                classes.append(classFollowing)
            }
        }
        self.classList.reloadData()
        
        let fetchRequest2 = NSFetchRequest(entityName: "ClassEntity")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest2, error: nil) as? [ClassEntity]{
            classes = []
            
            for (var i = 0; i < fetchResults.count; i++){
                var entity = fetchResults[i]
                var classToAdd: JSON! = classDict![entity.deptKey][entity.courseKey][entity.sectionKey]
                var x = classToAdd["name"].string!
                var classFollowing = ClassModel(name: classToAdd["name"].string!, course: classToAdd["section"].string!, status: classToAdd["status"].string!, professor: classToAdd["professor"].string!, room: classToAdd["room"].string!)
                classes.append(classFollowing)
            }
        }
        self.classList.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        addNewClassButton.layer.borderWidth = 2
        addNewClassButton.layer.borderColor = UIColor.orangeColor().CGColor
        addNewClassButton.layer.cornerRadius = 10.0
        self.populateClassList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
