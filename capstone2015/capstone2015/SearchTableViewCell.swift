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
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    
    var professor: String!
    var room: String!
    var time: String!
    
    func setCell(className: String, courseNumber: String, status: String, professor: String, room: String, time: String) {
        self.className.text = className
        self.courseNumber.text = courseNumber
        self.status.text = status
        self.professor = professor
        
        self.professorLabel.text = professor
        self.roomLabel.text = room
        self.timeLabel.text = time
        
        self.room = room
        followButton.layer.borderWidth = 1.35
        followButton.layer.borderColor = UIColor.orangeColor().CGColor
        followButton.layer.cornerRadius = 5.0
    }
    
    var deptKey: String!
    var courseKey: String!
    var sectionKey: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addClass(sender: UIButton) {
        followButton.setTitle("Unfollow", forState: UIControlState.Normal)
        followButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        let entity = NSEntityDescription.insertNewObjectForEntityForName("ClassEntity", inManagedObjectContext: self.managedObjectContext!) as ClassEntity
        entity.deptKey = self.deptKey
        entity.courseKey = self.courseKey
        entity.sectionKey = self.sectionKey
        managedObjectContext!.save(nil)
    }

}
