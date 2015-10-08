//
//  MapViewContainer.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

class MapViewContainer: UIViewController
{
  
  @IBOutlet var mapView: MapView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "redrawMap", name: UIDeviceOrientationDidChangeNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "highlightedFeatureOnMap:", name: "featureSelectedForMapping", object: nil)
  }
  
  func redrawMap()
  {
    self.mapView.setNeedsDisplay()
  }
  
  func highlightedFeatureOnMap(notification: NSNotification)
  {
    let userInfo = notification.userInfo as! [String : Int]
    println(userInfo)
  }
  
}