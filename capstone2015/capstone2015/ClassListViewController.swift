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
    
    lazy var classesFollowing : [Class]? = {
        let fetchRequest = NSFetchRequest(entityName: "Class")
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Class] {
            return fetchResults
        } else {
            return nil
        }
    }()
    
    @IBOutlet weak var classList: UITableView!
    
    @IBAction func addNewClass(sender: UIButton) {
        //tableData.append(Class(className: "Biostatistics 315", status: "Open"))
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
        newItem.name = "English 101"
        newItem.availability = "Closed"
        
        classesFollowing?.append(newItem)
        
        classList?.reloadData()
    }
    
    //var tableData = [Class]()
    var newClass : String = ""
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //      return tableData.count
        return classesFollowing!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
       // cell.textLabel?.text = "\(tableData[indexPath.row].className)"
       // cell.detailTextLabel?.text = "\(tableData[indexPath.row].status)"

        cell.textLabel?.text = "\(classesFollowing![indexPath.row].name)"
        cell.detailTextLabel?.text = "\(classesFollowing![indexPath.row].availability)"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
        newItem.name = "Humanities 111"
        newItem.availability = "Closed"
        
        let newItem2 = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
        newItem2.name = "Computer Science 105"
        newItem2.availability = "Open"
        
       //tableData = [Class(className: "Humanities 111",status: "Closed"), Class(className: "Computer Science 105",status: "Open")]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
