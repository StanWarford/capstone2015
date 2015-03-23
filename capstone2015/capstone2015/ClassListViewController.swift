//
//  ClassListViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 1/29/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData

class ClassListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        cell.setCell(classFollowing.name, course: classFollowing.course, status: classFollowing.status)
        if (classFollowing.status == "Open"){
            cell.status.textColor = alizarinRed
        } else {
            cell.status.textColor = emeraldGreen
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateClassList()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.populateClassList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
