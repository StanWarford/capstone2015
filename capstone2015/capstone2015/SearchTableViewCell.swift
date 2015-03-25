//
//  SearchTableViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/24/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewCell: UITableViewCell {

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
        }()
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var status: UILabel!
    
    var professor: String!
    var room: String!
    
    func setCell(className: String, courseNumber: String, status: String, professor: String, room: String) {
        self.className.text = className
        self.courseNumber.text = courseNumber
        self.status.text = status
        self.professor = professor
        self.room = room
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addClass(sender: UIButton) {
        let newClass = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext!) as Class
        newClass.name = self.className.text!
        newClass.course = self.courseNumber.text!
        newClass.status = self.status.text!
        newClass.professor = self.professor
        newClass.room = self.room
        managedObjectContext!.save(nil)
    }

}
