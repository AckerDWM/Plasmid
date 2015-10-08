//
//  MapView.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/7/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

@IBDesignable
class MapView: UIView
{

  let sortedFeatures = sorted(Global.activeSeqObject.features)
  {
    (s1: Seq.Feature, s2: Seq.Feature) in
    return s1.positions[0].start < s2.positions[0].start
  }
  
  var selectedFeatureIndex: Int?
  {
    didSet(oldVal)
    {
      self.setNeedsDisplay()
    }
  }
  
  override func drawRect(rect: CGRect)
  {
    // set map inner radius
    var length = CGFloat()
    if self.bounds.size.height > self.bounds.size.width
    {
      length = self.bounds.width
    }
    else
    {
      length = self.bounds.height
    }
    let radius = length / 4
    // define center point
    let centerX = self.bounds.width / 2
    let centerY = self.bounds.height / 2
    let centerPoint = CGPoint(x: centerX, y: centerY)
    // create base circle
    let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: 6.28, clockwise: true)
    path.closePath()
    path.lineWidth = 4
    path.stroke()
    // find fraction of circumference and radius for each feature
    var arcs: [(startRadians: CGFloat, endRadians: CGFloat, range: NSRange, ring: Int, color: UIColor, selected: Bool)] = []
    let sequenceLength = CGFloat(count(Global.activeSeqObject.sequence))
    for (var i = 0; i < self.sortedFeatures.count; i++)
    {
      let feature = self.sortedFeatures[i]
      for position in feature.positions
      {
        var newArc: (startRadians: CGFloat, endRadians: CGFloat, range: NSRange, ring: Int, color: UIColor, selected: Bool) = (startRadians: CGFloat(), endRadians: CGFloat(), range: NSRange(), ring: 1, color: UIColor.blackColor(), selected: false)
        let startIndex = position.start
        let endIndex = position.end ?? startIndex + 1;
        newArc.startRadians = (CGFloat(startIndex) / sequenceLength) * 6.28
        newArc.endRadians = (CGFloat(endIndex) / sequenceLength) * 6.28
        newArc.range = NSRange(location: startIndex, length: distance(startIndex, endIndex))
        for arc in arcs
        {
          let intersection = NSIntersectionRange(newArc.range, arc.range)
          if intersection.length > 0
          {
            newArc.ring++
          }
        }
        if i == self.selectedFeatureIndex
        {
          newArc.selected = true
        }
        // add color
        // ...
        let new = newArc
        arcs.append(new)
      }
    }
    // draw feature arcs
    for arc in arcs
    {
      let arcRadius = radius + 20 * CGFloat(arc.ring)
      let path = UIBezierPath(arcCenter: centerPoint, radius: arcRadius, startAngle: arc.startRadians, endAngle: arc.endRadians, clockwise: true)
      if arc.selected
      {
        path.moveToPoint(centerPoint)
        path.closePath()
        arc.color.setFill()
        path.stroke()
      }
      else
      {
        path.lineWidth = 10
        arc.color.setStroke()
        path.stroke()
      }
    }
  }

}
