//
//  DeptListTableViewCell.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 3/18/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

//A View representation of department information for the DepartmentViewController
class DeptListTableViewCell: UITableViewCell {

    @IBOutlet weak var deptName: UILabel!
    
    @IBAction func showCourses(sender: UIButton) {
        deptOfInterest = deptName.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(deptName: String) {
        self.deptName.text = deptName
    }
}
