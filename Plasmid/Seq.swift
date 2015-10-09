//
//  Seq.swift
//  Test
//
//  Created by Daniel Acker on 9/3/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

class Seq {
  class Feature {
    var label: String?
    var color: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat)?
    var key = String()
    var joinType: String?
    var positions: [(start: Int, end: Int?, delimiter: String?, onCodingSequence: Bool)] = []
    var qualifiers: [(definition: String, content: String?)] = []
  }
  var metadata = [
    "LOCUS": String(),
    "DEFINITION": String(),
    "ACCESSION": String(),
    "VERSION": String(),
    "KEYWORDS": String(),
    "SOURCE": String(),
    "ORGANISM": String()]
  var features: [Feature] = []
  var sequence = String()
  var references: [(reference: String, authors: String?, title: String?, journal: String?, pubmed: String?)] = []
  var comments: [String] = []
  var locus: String {
    get {
      return metadata["LOCUS"]!
    }
    set(newVal) {
      metadata["LOCUS"] = newVal
    }
  }
  var definition: String {
    get {
      return metadata["DEFINITION"]!
    }
    set(newVal) {
      metadata["DEFINITION"] = newVal
    }
  }
  var accession: String {
    get {
      return metadata["ACCESSION"]!
    }
    set(newVal) {
      metadata["ACCESSION"] = newVal
    }
  }
  var version: String {
    get {
      return metadata["VERSION"]!
    }
    set(newVal) {
      metadata["VERSION"] = newVal
    }
  }
  var source: String {
    get {
      return metadata["SOURCE"]!
    }
    set(newVal) {
      metadata["SOURCE"] = newVal
    }
  }
  var organism: String {
    get {
      return metadata["ORGANISM"]!
    }
    set(newVal) {
      metadata["ORGANISM"] = newVal
    }
  }
  var keywords: String {
    get {
      return metadata["KEYWORDS"]!
    }
    set(newVal) {
      metadata["KEYWORDS"] = newVal
    }
  }
  
  var stringRepresentation: String {
    get {
      var string = String()
      // Add metadata
      string += "LOCUS       " + self.locus + "\n"
      string += "DEFINITION  " + self.definition + "\n"
      string += "ACCESSION   " + self.accession + "\n"
      string += "VERSION     " + self.version + "\n"
      string += "KEYWORDS    " + self.keywords + "\n"
      string += "SOURCE      " + self.source + "\n"
      string += "  ORGANISM  " + self.organism + "\n"
      // Add references
      for ref in self.references {
        string += "REFERENCE   " + ref.reference + "\n"
        if let authors = ref.authors {
          string += "  AUTHORS   " + authors + "\n"
        }
        if let title = ref.title {
          string += "  TITLE     " + title + "\n"
        }
        if let journal = ref.journal {
          string += "  JOURNAL   " + journal + "\n"
        }
        if let pubmed = ref.pubmed {
          string += "  PUBMED    " + pubmed + "\n"
        }
      }
      // Add comments
      for comment in self.comments {
        string += "COMMENT     " + comment + "\n"
      }
      // Add features
      string += "FEATURES             Location/Qualifiers" + "\n"
      for feat in self.features {
        let whiteSpacesToAdd = 16 - count(feat.key)
        let spaceArray = [String](count:whiteSpacesToAdd, repeatedValue:" ")
        var featDefLine = "     " + feat.key + "".join(spaceArray)
        var segmentStrings: [String] = []
        for segment in feat.positions {
          var segmentString = "\(segment.start)"
          if segment.delimiter != nil && segment.end != nil {
            segmentString += "\(segment.delimiter!)" + "\(segment.end!)"
          }
          if segment.onCodingSequence == false {
            segmentString = "complement(" + segmentString + ")"
          }
          segmentStrings.append(segmentString)
        }
        if feat.joinType == "join" {
          featDefLine += "join(" + ",".join(segmentStrings) + ")"
        } else if feat.joinType == "order" {
          featDefLine += "order(" + ",".join(segmentStrings) + ")"
        } else {
          featDefLine += segmentStrings[0]
        }
        string += featDefLine + "\n"
        for qual in feat.qualifiers {
          var qualString = "                     /" + qual.definition
          if let content = qual.content {
            qualString += "=" + content
          }
          string += qualString + "\n"
        }
      }
      // Add sequence
      string += "ORIGIN\n"
      var lineToAppend = String()
      var tenNucleotidesToAppend = String()
      let nucleotideArray = Array(self.sequence)
      for i in 0...nucleotideArray.count - 1 {
        tenNucleotidesToAppend += String(nucleotideArray[i])
        if count(tenNucleotidesToAppend) == 10 {
          lineToAppend += String(tenNucleotidesToAppend) + " "
          tenNucleotidesToAppend = ""
        }
        if count(lineToAppend) == 66 {
          let indexString = String(i - 58)
          let indexDigitCount = count(indexString)
          var newIndexStr = indexString + " "
          for i in 0...9 - indexDigitCount {
            newIndexStr = " " + newIndexStr
          }
          string += "\n" + newIndexStr + lineToAppend
          lineToAppend = String()
        }
        if i == nucleotideArray.count - 1 {
          var trailingNucleotidesToAdd = String()
          if count(lineToAppend) > 0 {
            trailingNucleotidesToAdd = lineToAppend + tenNucleotidesToAppend
          } else {
            trailingNucleotidesToAdd = tenNucleotidesToAppend
          }
          let strippedString = (trailingNucleotidesToAdd as NSString).stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: NSMakeRange(0, count(trailingNucleotidesToAdd)))
          let numberOfNucleotidesAdded = count(strippedString) - 2
          let indexString = String(i - numberOfNucleotidesAdded)
          let indexDigitCount = count(indexString)
          var newIndexStr = indexString + " "
          for i in 0...9 - indexDigitCount {
            newIndexStr = " " + newIndexStr
          }
          string += "\n" + newIndexStr + trailingNucleotidesToAdd
        }
      }
      
      string += "\n\\\\"
      
      return string
    }
  }
  
}