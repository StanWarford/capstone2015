//
//  DepartmentViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/10/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

//A Controller that populates and formats the DeptListView
class DepartmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var deptList: UITableView!
    
    var depts = [String]()
    
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
    
    //Lists the keys of the classDict (JSON Dictionary of classes)
    func populateDeptList() {
        if let dict = classDict {
            self.depts = sorted(dict.dictionary!.keys.array) {$0 < $1}
        }
    }
    
    //Creates DeptListTableViewCells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DeptListTableViewCell = tableView.dequeueReusableCellWithIdentifier("DepartmentCell") as! DeptListTableViewCell
        // create cell
        let deptName = depts[indexPath.row]
        cell.setCell(deptName)
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
}