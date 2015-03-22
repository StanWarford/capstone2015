//
//  DepartmentViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/10/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class DepartmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var deptList: UITableView!
    
    var depts = [String]()
    
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        populateDeptList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.depts.count
    }
    
    func populateDeptList() {
        self.depts = classDict.dictionary!.keys.array
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DeptListTableViewCell = tableView.dequeueReusableCellWithIdentifier("DepartmentCell") as DeptListTableViewCell
        // create cell
        let deptName = depts[indexPath.row]
        cell.setCell(deptName)
        return cell
    }
}