//
//  settings.swift
//  dbSync
//
//  Created by Kalle Hansson on 2017-07-31.
//  Copyright © 2017 SchlagerKhan. All rights reserved.
//

import Foundation
import SwiftyJSON
import FileKit

class Settings : NSObject {
    let H = Helper();
    
    var settingsFilePathString : String!
    var settingsFilePath : Path!
    var settingsFile : DataFile!
    var settings : JSON!
    var currentGroupAlias: String = "";
    
    override init () {
        super.init();
        
        let userDirectory = NSHomeDirectory();
        settingsFilePathString = userDirectory + "/.dbsync/config";
        settingsFilePath = Path(settingsFilePathString);
        settingsFile = DataFile(path: settingsFilePath);
        
        ensureFileSystem();
        settings = readSettings();
        setCurrentGroup(0);
    }
    
    func initSettings () {
        ensureFileSystem();
        settings = readSettings();
        currentGroupAlias = settings["groups"][0]["name"].stringValue;
    }
    func ensureFileSystem () {
        if !settingsFilePath.exists {
            H.createFile(path: settingsFilePath);
            initDefaultSettings();
        }
    }
    
    func initDefaultSettings ()  {
        let defaultSettings = JSON([
            "groups": [
                [
                    "alias": "example-group",
                    "name": "Example Group",
                    "databases": [
                        [
                            "alias": "example-database",
                            "name": "Example Database",
                            "host": "example-host",
                            "password": "example-pw",
                            "port": "8889"
                        ],
                        [
                            "alias": "example-database-2",
                            "name": "Example Database 2",
                            "host": "example-host-2",
                            "password": "example-pw-2",
                            "port": "8890"
                        ]
                    ]
                ]
            ]
            ]);
        
        do {
            let settingsFile = DataFile(path: settingsFilePath);
            try settingsFile.write(defaultSettings.rawData());
        } catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
    }
    func readSettings() -> JSON {
        do {
            let settingsFile = DataFile(path: settingsFilePath);
            let settingsData = try settingsFile.read();
            let settingsJSON = JSON(settingsData);
            
            return settingsJSON;
        } catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
            
            return JSON.null;
        }
    }
    
    func getGroups() -> JSON { return settings["groups"]; }
    func getGroup(_ alias: String) -> JSON {
        let groups = getGroups();
        
        for (_, group):(String, JSON) in groups {
            if (group["alias"].stringValue == alias) {
                return group;
            }
        }
        
        return JSON.null;
    }
    func getDatabases(_ groupAlias : String) -> JSON {
        let group = getGroup(groupAlias);
        return group["databases"];
    }
    func getDatabaseData(_ groupAlias : String, _ databaseAlias: String) -> JSON {
        let databases = getDatabases(groupAlias);
        
        for (_, database):(String, JSON) in databases {
            if (database["alias"].stringValue == databaseAlias) {
                return database;
            }
        }
        
        return JSON.null;
    }
    
    func setCurrentGroup(_ newIndex : Int) {
        currentGroupAlias = settings["groups"][newIndex]["alias"].stringValue;
    }
//    func setCurrentGroup(_ newAlias : String) {
//        currentGroupAlias = newAlias;
//    }
    func getCurrentGroup() -> JSON {
        return getGroup(currentGroupAlias);
    }
    
}
