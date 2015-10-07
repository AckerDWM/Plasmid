//
//  GenbankParser.swift
//  Plasmid
//
//  Created by Daniel Acker on 9/3/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

class GenbankParser {
  
  static let genbankKeys = GenbankParser.parseGenbankFeatureKeys()
  
  static let metadataPrefixes = ["LOCUS", "DEFINITION", "ACCESSION", "VERSION", "KEYWORDS", "SOURCE", "ORGANISM"]
  
  static func parseGenbankFeatureKeys() -> [String] {
    let keysPath = NSBundle.mainBundle().pathForResource("genbankAppendixII_featureKeys", ofType: "txt")
    let keysString = NSString(contentsOfFile: keysPath!, encoding: NSUTF8StringEncoding, error: nil)
    let lines = keysString!.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
    var keys: [String] = []
    for line in lines {
      if line.hasPrefix("Feature Key") {
        var key = (line as! NSString).substringFromIndex(count("Feature Key"))
        keys.append(key.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()))
      }
    }
    return keys
  }
  
  static func parseGenbank(genbankString: String) -> Seq {
    var newSeq = Seq()
    let numberRegex = NSRegularExpression(pattern: "[0-9^]+", options: nil, error: nil)
    var lines = genbankString.componentsSeparatedByCharactersInSet(.newlineCharacterSet()) as [String]
    for (var i = 0; i < count(lines); i++) {
      lines[i] = lines[i].stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
    }
    
    // combine descriptions spanning multiple lines into single lines
    var combinedLines: [String] = []
    var newLine: String?
    prefixLineLoop: for line in lines {
      var prefixes = ["ORIGIN", "LOCUS", "DEFINITION", "ACCESSION", "VERSION", "SOURCE", "ORGANISM", "FEATURES", "REFERENCE", "AUTHORS", "TITLE", "JOURNAL", "PUBMED", "KEYWORDS", "/", "COMMENT"]
      prefixes.extend(genbankKeys)
      for prefix in prefixes {
        if line.hasPrefix(prefix) {
          if let new = newLine {
            combinedLines.append(new)
          }
          newLine = line
          continue prefixLineLoop
        }
      }
      newLine = newLine! + line
    }
    if let new = newLine {
      combinedLines.append(new)
    }
    
    var fileSection = "metadata"
    var newFeature: Seq.Feature?
    var newReference: (reference: String, authors: String?, title: String?, journal: String?, pubmed: String?)?
    lineLoop: for line in combinedLines {
      // Transition to next section of file
      if line.hasPrefix("REFERENCE") {
        fileSection = "references"
        //
      } else if line.hasPrefix("COMMENT") {
        fileSection = "comments"
      } else if line.hasPrefix("FEATURES") {
        fileSection = "features"
        continue lineLoop
      } else if line.hasPrefix("ORIGIN") {
        // Add the final reference to the sequence if it exists
        if let reference = newReference {
          newSeq.references.append(reference)
        }
        // Add the final feature to the sequence if it exists
        if let feature = newFeature {
          newSeq.features.append(feature)
        }
        fileSection = "sequence"
      } else if line.hasPrefix("//") {
        return newSeq
      }
      switch fileSection {
      case "metadata":
        // Parse metadata
        for prefix in metadataPrefixes {
          if line.hasPrefix(prefix) {
            var data = (line as NSString).substringFromIndex(count(prefix))
            data = data.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
            newSeq.metadata[prefix] = data
            continue lineLoop
          }
        }
      case "features":
        // Parse features
        for key in GenbankParser.genbankKeys {
          if line.hasPrefix(key) { // then it is a feature definition
            if let feature = newFeature {
              // Add the feature to the sequence if it exists
              newSeq.features.append(feature)
            }
            // Start a new feature with key
            newFeature = Seq.Feature()
            newFeature?.key = key
            // Parse location <- working on this...
            let locationString = (line as NSString).substringFromIndex(count(key))
            // parse join type
            if (locationString as NSString).containsString("join") {
              newFeature?.joinType = "join"
            } else if (locationString as NSString).containsString("order") {
              newFeature?.joinType = "order"
            }
            // Split into individual location segments
            let segmentsToJoin = locationString.componentsSeparatedByString(",")
            for segment in segmentsToJoin {
              var newSegmentTouple: (start: Int, end: Int?, delimiter: String?, onCodingSequence: Bool) = (start: Int(), end: nil, delimiter: nil, onCodingSequence: true)
              if (segment as NSString).containsString("..>") {
                newSegmentTouple.delimiter = "..>"
              } else if (segment as NSString).containsString("<..") {
                newSegmentTouple.delimiter = "<.."
              } else if (segment as NSString).containsString("..") {
                newSegmentTouple.delimiter = ".."
              }
              if (segment as NSString).containsString("complement") {
                newSegmentTouple.onCodingSequence = false
              }
              // Parse location starts/ends
              let numberMatches = numberRegex?.matchesInString(segment, options: nil, range: NSMakeRange(0, count(segment)))
              if let matches = numberMatches {
                for (var i = 0; i < matches.count; i++) {
                  var location = (locationString as NSString).substringWithRange(matches[i].range)
                  if (location as NSString).containsString("^") {
                    let carrotRange = (location as NSString).rangeOfString("^")
                    location = (location as NSString).substringToIndex(carrotRange.location)
                    // Indicate that this is in between...........
                  }
                  if i == 0 {
                    println(location)
                    newSegmentTouple.start = location.toInt()!
                  } else {
                    newSegmentTouple.end = location.toInt()!
                  }
                }
              }
              let x = newSegmentTouple
              newFeature?.positions.append(x)
            }
            continue lineLoop
          } else if line.hasPrefix("/") {
            // Parse qualifiers
            let trimmedLine = (line as NSString).substringFromIndex(1)
            let rangeOfEquals = (trimmedLine as NSString).rangeOfString("=")
            var newQualifierContent: String?
            var newQualifierDef = trimmedLine
            if rangeOfEquals.length > 0 {
              newQualifierContent = (trimmedLine as NSString).substringFromIndex(rangeOfEquals.location + 1)
              newQualifierDef = (trimmedLine as NSString).substringToIndex(rangeOfEquals.location)
            }
            let newQualifier = (definition: newQualifierDef, content: newQualifierContent)
            newFeature?.qualifiers.append(newQualifier)
            continue lineLoop
          }
        }
      case "references":
        if line.hasPrefix("REFERENCE") {
          if let ref = newReference {
            newSeq.references.append(ref)
          }
          var reference = (line as NSString).substringFromIndex(count("REFERENCE"))
          reference = reference.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          newReference = (reference: reference, authors: nil, title: nil, journal: nil, pubmed: nil)
        } else if line.hasPrefix("AUTHORS") {
          var authors = (line as NSString).substringFromIndex(count("AUTHORS"))
          authors = authors.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          newReference!.authors = authors
        } else if line.hasPrefix("TITLE") {
          var title = (line as NSString).substringFromIndex(count("TITLE"))
          title = title.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          newReference!.title = title
        } else if line.hasPrefix("JOURNAL") {
          var journal = (line as NSString).substringFromIndex(count("JOURNAL"))
          journal = journal.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          newReference!.journal = journal
        } else if line.hasPrefix("PUBMED") {
          var pubmed = (line as NSString).substringFromIndex(count("PUBMED"))
          pubmed = pubmed.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
          newReference!.pubmed = pubmed
        }
      case "comments":
        var comment = (line as NSString).substringFromIndex(count("COMMENT"))
        comment = comment.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        newSeq.comments.append(comment)
      case "sequence":   // Parse sequence
        let nucleotideRegex = NSRegularExpression(pattern: "[ATGCatcg]+", options: nil, error: nil)
        let matches = nucleotideRegex?.matchesInString(line, options: nil, range: NSMakeRange(count("ORIGIN"), count(line) - count("ORIGIN")))
        var sequenceExtension = String()
        for match in matches! {
          sequenceExtension += (line as NSString).substringWithRange(match.range)
        }
        newSeq.sequence += sequenceExtension.uppercaseString
      default:
        println(fileSection)
      }
    }
    return newSeq
  }
  
}



