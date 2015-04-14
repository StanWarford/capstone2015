//
//  SearchViewController.swift
//  capstone2015
//
//  Created by Jeremiah Montoya on 2/9/15.
//  Copyright (c) 2015 Pepperdine Computer Science. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResults: UITableView!
    @IBAction func changeFilter(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case 0: filter = "section"
        case 1: filter = "name"
        case 2: filter = "department"
        case 3: filter = "professor"
        default: print("There is no fourth filter. This should not occur.")
        }
        searchForResults(searchBar.text)
    }
    
    func searchForResults (searchText: String) {
        filteredModel = []
        
        for section in classList {
            if (section[filter].string!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
                filteredModel.append(section)
            }
        }
        
        searchResults.reloadData()
    }
    
    var filteredModel = [JSON]()
    var filter = "section"
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchForResults(searchBar.text)
        searchBar.resignFirstResponder()

    }
    
    var extendedHeight: NSIndexPath?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (extendedHeight == indexPath) {
            extendedHeight = nil
        } else {
            extendedHeight = indexPath
        }
        searchResults.beginUpdates()
        searchResults.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (extendedHeight == indexPath) {
            return 132
        }
        return 68
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as SearchTableViewCell
        let classFollowing = filteredModel[indexPath.row]
        cell.setCell(classFollowing["name"].string!,
            courseNumber: classFollowing["section"].string!,
            status: classFollowing["status"].string!,
            professor: classFollowing["professor"].string!,
            room: classFollowing["room"].string!,
            time: classFollowing["meeting"].string!)
        if (classFollowing["status"] == "Open"){
            cell.status.textColor = UIColor.orangeColor()
        } else {
            cell.status.textColor = UIColor.grayColor()
        }
        
        cell.deptKey = split(classFollowing["section"].string!) {$0 == " "} [0]
        cell.courseKey = split(classFollowing["section"].string!) {$0 == "."} [0]
        cell.sectionKey = classFollowing["subject"].string!
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModel.count
    }

    @IBAction func hideKeyboard(sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar.backgroundColor = UIColor(red: 13.0/255, green: 36.0/255,blue: 109.0/255, alpha: 1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
