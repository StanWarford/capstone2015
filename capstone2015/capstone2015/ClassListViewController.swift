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
    
    @IBOutlet weak var addNewClassButton: UIButton!
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    @IBOutlet weak var classList: UITableView!
    
    var classes = [ClassModel]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClassListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClassListCell") as ClassListTableViewCell
        // create cell
        let classFollowing = classes[indexPath.row]
        cell.setCell(classFollowing.name, course: classFollowing.course, status: classFollowing.status.uppercaseString + " ●")
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
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            classes.removeAtIndex(indexPath.row) // To-do: Delete from core data instead
            // remove the deleted item from the model
            let fetchRequest = NSFetchRequest(entityName: "Class")
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Class]{
                self.managedObjectContext!.deleteObject(fetchResults[indexPath.row] as NSManagedObject)
            }
            self.managedObjectContext!.save(nil)
            // remove the deleted item from the `UITableView`
            self.classList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor.orangeColor()
        self.populateClassList()
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
