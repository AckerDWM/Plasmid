//
//  MapFeatureListVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class MapFeatureListVC: UITableViewController
{

  let sortedFeatures = sorted(Global.activeSeqObject.features)
  {
      (s1: Seq.Feature, s2: Seq.Feature) in
      return s1.positions[0].start < s2.positions[0].start
  }

  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    NSNotificationCenter.defaultCenter().postNotificationName("featureSelectedForMapping", object: nil, userInfo: ["selectedIndex" : indexPath.row])
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return sortedFeatures.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

    // Configure the cell...
    let feature = sortedFeatures[indexPath.row]
    let color = UIColor(hue: feature.color!, saturation: 1, brightness: 1, alpha: 1)
    cell.backgroundColor = color
    let label = cell.viewWithTag(1) as! UILabel
    label.text = feature.key
    let textView = cell.viewWithTag(2) as! UITextView
    textView.text = feature.label
    textView.backgroundColor = UIColor.clearColor()
    
    return cell
  }

}
