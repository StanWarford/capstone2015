//
//  CoursesTableViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/21/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

//A View representation of course information used by CoursesViewController
class CoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    
    @IBAction func showSections(sender: UIButton) {
        courseOfInterest = courseName.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(courseName: String) {
        self.courseName.text = courseName
    }

}
