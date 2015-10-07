//
//  DropboxManager.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/7/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

class DropboxManager
{
  
  static func connect()
  {
    let accountManager = DBAccountManager(appKey: "smuyghqxojdd1hr", secret: "qk4c5800opujmkl")
    let sharedManager: Void = DBAccountManager.setSharedManager(accountManager)
    let fileSystem = DBFilesystem(account: DBAccountManager.sharedManager().linkedAccount)
    DBFilesystem.setSharedFilesystem(fileSystem)
  }
  
  static func linkAccount(controller: UIViewController)
  {
    DBAccountManager.sharedManager().linkFromController(controller)
  }
  
  static func listFiles(completion: ([DBFileInfo]) -> Void)
  {
    var error: DBError?
    
    if DBFilesystem.sharedFilesystem() != nil
    {
      let fileInfos = DBFilesystem.sharedFilesystem().listFolder(DBPath.root(), error: &error) as! [DBFileInfo]
      completion(fileInfos)
    }
  }
  
  static func createFile(relativePath: String, contents: String, completion: () -> Void)
  {
    if DBFilesystem.sharedFilesystem() != nil
    {
      let path = DBPath.root().childPath(relativePath)
      DBFilesystem.sharedFilesystem().createFile(path, error: nil)
    }
    completion()
  }
  
  static func saveFile(dbPath: DBPath, contents: String, completion: (Bool) -> Void)
  {
    var successful = false
    if DBFilesystem.sharedFilesystem() != nil
    {
      let file = DBFilesystem.sharedFilesystem().openFile(dbPath, error: nil)
      successful = file.writeString(contents, error: nil)
    }
    completion(successful)
  }
  
  static func openFile(dbPath: DBPath, completion: (String) -> Void)
  {
    if DBFilesystem.sharedFilesystem() != nil
    {
      let file = DBFilesystem.sharedFilesystem().openFile(dbPath, error: nil)
      let contents = file.readString(nil)
      completion(contents)
    }
  }
  
  static func deleteFile(dbPath: DBPath, completion: (Bool) -> Void)
  {
    if DBFilesystem.sharedFilesystem() != nil
    {
      let successful = DBFilesystem.sharedFilesystem().deletePath(dbPath, error: nil)
      completion(successful)
    }
  }
  
}