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
    
    var classes: [ClassModel] = [ClassModel]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClassListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClassListCell") as ClassListTableViewCell
        // create cell
        let classFollowing = classes[indexPath.row]
        cell.setCell(classFollowing.name, course: classFollowing.course, status: classFollowing.status)
        if (classFollowing.status == "Open"){
            cell.backgroundColor = UIColor.greenColor()
        } else {
            cell.backgroundColor = UIColor.redColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            classes.removeAtIndex(indexPath.row) // To-do: Delete from core data instead
            classList.reloadData()
        }
    }
    
    func populateClassList(){
        let fetchRequest = NSFetchRequest(entityName: "Class")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Class]{
            for (var i = 0; i < fetchResults.count; i++){
                var classFollowing = ClassModel(name: fetchResults[i].name, course: fetchResults[i].course, status: fetchResults[i].status, professor: fetchResults[i].professor, room: fetchResults[i].room)
                classes.append(classFollowing)
            }
        }
        self.classList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let newClass = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
//        newClass.name = "COSC 101"
//        newClass.course = "Intro to Computer Science"
//        newClass.status = "Open"
//        newClass.professor = "Stan Warford"
//        newClass.room = "RAC 350"
//        let newClass2 = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
//        newClass2.name = "HUM 305"
//        newClass2.course = "Western Culture"
//        newClass2.status = "Closed"
//        newClass2.professor = "Sonya Sorrell"
//        newClass2.room = "PLC 10"
        self.populateClassList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
