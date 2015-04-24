//
//  SectionsTableViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/16/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit
import CoreData

//A View representation of section information used by SectionsViewController
class SectionsTableViewCell: UITableViewCell {

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
        }()
    
    var deptKey: String!
    var courseKey: String!
    var sectionKey: String!
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var unfollowButton: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var professor: String!
    var room: String!
    
    func setCell(className: String, courseNumber: String, status: String, professor: String, room: String, time: String) {
        self.className.text = className
        self.courseNumber.text = courseNumber
        self.status.text = status.uppercaseString
        self.professor = professor
        self.room = room
        self.professorLabel.text = professor
        self.timeLabel.text = time
        self.roomLabel.text = room
        unfollowButton.layer.borderWidth = 1.35
        unfollowButton.layer.borderColor = UIColor.orangeColor().CGColor
        unfollowButton.layer.cornerRadius = 5.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Adds the class to the list of classes being followed by updating Core Data
    @IBAction func addClass(sender: UIButton) {
        let newClass = NSEntityDescription.insertNewObjectForEntityForName("ClassEntity", inManagedObjectContext: self.managedObjectContext!) as! ClassEntity
        newClass.deptKey = self.deptKey
        newClass.courseKey = self.courseKey
        newClass.sectionKey = self.sectionKey
        managedObjectContext!.save(nil)
    }

}
