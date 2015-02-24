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
    
    var alizarinRed = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    var emeraldGreen = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
        }()
    
    @IBOutlet weak var sectionsList: UITableView!
    
    @IBAction func swipeBack(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    var sections = [ClassModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var section = ClassModel(name: "COSC 101", course: "Intro to Computer Science", status: "Closed", professor: "Dr. Warford", room: "RAC 120")
        var section2 = ClassModel(name: "HUM 111", course: "Western Culture", status: "Open", professor: "Dr. Sorrell", room: "PLC 125")
        var section3 = ClassModel(name: "MATH 220", course: "Automata Theory", status: "Open", professor: "Dr. Iga", room: "RAC 305")
        sections.append(section)
        sections.append(section2)
        sections.append(section3)
        sectionsList.reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SectionsTableViewCell = tableView.dequeueReusableCellWithIdentifier("SectionsCell") as SectionsTableViewCell
        // create cell
        let classFollowing = sections[indexPath.row]
        cell.setCell(classFollowing.name, courseNumber: classFollowing.course, status: classFollowing.status, professor: classFollowing.professor, room: classFollowing.room)
        if (classFollowing.status == "Open"){
            cell.backgroundColor = alizarinRed
        } else {
            cell.backgroundColor = emeraldGreen
        }
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
