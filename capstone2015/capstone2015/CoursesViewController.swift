//
//  CoursesViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/23/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var courses = [String]()
    var indexShift = 0
    
    @IBAction func swipeBack(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        populateCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateCourses(){
        self.courses = classDict[deptOfInterest!].dictionary!.keys.array
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CoursesTableViewCell = tableView.dequeueReusableCellWithIdentifier("CourseCell") as CoursesTableViewCell
        // create cell
        if (courses[indexPath.row] == "subject") {
            indexShift = 1
        }
        let courseName = courses[indexPath.row + indexShift]
        cell.setCell(courseName)
        if (indexPath.row == self.courses.count - 1){
            indexShift = 0
        }
        return cell
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
