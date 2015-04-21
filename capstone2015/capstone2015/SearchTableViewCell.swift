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
        self.status.text = status.uppercaseString
        self.professor = professor
        
        self.professorLabel.text = professor
        self.roomLabel.text = room
        self.timeLabel.text = time
        
        self.room = room
        followButton.layer.borderWidth = 1.35
        followButton.layer.borderColor = pepperdineOrange.CGColor
        followButton.layer.cornerRadius = 5.0
        
        let fetchRequest = NSFetchRequest(entityName: "ClassEntity")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ClassEntity]{
            classes = []
            for (var i = 0; i < fetchResults.count; i++){
                var entity = fetchResults[i]
                var classAdded: JSON! = classDict![entity.deptKey][entity.courseKey][entity.sectionKey]
                if (classAdded["section"].string! == courseNumber){
                    setAsUnfollow()
                    break
                }
            }
        }
        
    }
    
    // not working at the moment
    func setAsUnfollow(){
        setAsFollow()
       // followButton.setTitle("Unfollow", forState: .Normal)
        //followButton.setTitle("Unfollow", forState: .Highlighted)
       // followButton.setTitle("Unfollow", forState: .Selected)
        //followButton.layer.borderColor = pepperdineGray.CGColor
    }
    
    func setAsFollow(){
        followButton.setTitle("Follow", forState: .Normal)
        followButton.setTitle("Follow", forState: .Highlighted)
        followButton.setTitle("Follow", forState: .Selected)
        followButton.layer.borderColor = pepperdineOrange.CGColor
    }
    
    var deptKey: String!
    var courseKey: String!
    var sectionKey: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addClass(sender: UIButton) {
        if(followButton.titleLabel?.text == "Follow"){
            setAsFollow()
        } else {
            setAsUnfollow()
        }
        let entity = NSEntityDescription.insertNewObjectForEntityForName("ClassEntity", inManagedObjectContext: self.managedObjectContext!) as ClassEntity
        entity.deptKey = self.deptKey
        entity.courseKey = self.courseKey
        entity.sectionKey = self.sectionKey
        managedObjectContext!.save(nil)
    }

}
