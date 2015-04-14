//
//  ClassListTableViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/16/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class ClassListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var room: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(className: String, course: String, status: String, time: String, professor: String, room: String) {
        self.className.text = className
        self.course.text = course
        self.status.text = status
        self.time.text = time
        self.professor.text = professor
        self.room.text = room
        followButton.layer.borderWidth = 1.35
        followButton.layer.borderColor = UIColor.orangeColor().CGColor
        followButton.layer.cornerRadius = 5.0
    }

}
