//
//  GroupModalController.swift
//  dbSync
//
//  Created by Kalle Hansson on 2017-07-31.
//  Copyright © 2017 SchlagerKhan. All rights reserved.
//

import Cocoa
import SwiftyJSON;

class GroupModalController : NSViewController {
    let settings = Settings();
    
    @IBOutlet weak var groupsTable: NSTableView!
    @IBOutlet weak var databasesTable: NSTableView!
    
    @IBOutlet weak var groupNameTitle: NSTextField!
    
    @IBOutlet weak var groupAliasTextbox: NSTextField!
    @IBOutlet weak var groupNameTextbox: NSTextField!
    @IBOutlet weak var databaseAliasTextbox: NSTextField!
    @IBOutlet weak var databaseNameTextbox: NSTextField!
    @IBOutlet weak var databaseHostTextbox: NSTextField!
    @IBOutlet weak var databasePasswordTextbox: NSTextField!
    @IBOutlet weak var databasePortTextbox: NSTextField!
    
    var selectedGroup : String = "";
    var selectedDatabase : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groups = settings.getGroups();
        selectedGroup = groups[0]["alias"].stringValue;
        let databases = settings.getDatabases(selectedGroup);
        selectedDatabase = databases[0]["alias"].stringValue;
        
        initTables();
        updateGraphics();
    }
    
    func initTables () {
        groupsTable.dataSource = self;
        groupsTable.delegate = self;
        
        databasesTable.dataSource = self;
        databasesTable.delegate = self;
    }
    
    func updateGraphics() {
        let group = settings.getGroup(selectedGroup);
        let database = settings.getDatabaseData(selectedGroup, selectedDatabase);
        
        if (group != JSON.null) {
            groupNameTitle.stringValue = group["name"].stringValue;
            
            groupAliasTextbox.stringValue = group["alias"].stringValue;
            groupNameTextbox.stringValue = group["name"].stringValue;
            
            if (database != JSON.null) {
                databaseAliasTextbox.stringValue = database["alias"].stringValue;
                databaseNameTextbox.stringValue = database["name"].stringValue;
                databaseHostTextbox.stringValue = database["host"].stringValue;
                databasePasswordTextbox.stringValue = database["password"].stringValue;
                databasePortTextbox.stringValue = database["port"].stringValue;
            }
        }
    }
    func updateTableSelection () {
        
    }
    
//    @IBAction func groupAliasChanged(_ sender: Any) {}
//    @IBAction func groupNameChanged(_ sender: Any) {}
//    @IBAction func databaseAliasChanged(_ sender: Any) {}
//    @IBAction func databaseHostChanged(_ sender: Any) {}
//    @IBAction func databasePasswordChanged(_ sender: Any) {}
//    @IBAction func databasePortChanged(_ sender: Any) {}
}

extension GroupModalController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let isGroupsTable = tableView == groupsTable;
        
        if isGroupsTable {
            return settings.getGroups().count
        } else {
            return settings.getDatabases(selectedGroup).count;
        }
    }
}
extension GroupModalController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let isGroupsTable = tableView == groupsTable;
        
        var item : JSON!
        if isGroupsTable  {
            let groups = settings.getGroups();
            item = groups[row];
        } else {
            let databases = settings.getDatabases(selectedGroup);
            item = databases[row];
        }
        
        if let cell = tableView.make(withIdentifier: "CellID", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = item["name"].stringValue;
            return cell;
        }
        return nil;
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        print(notification);
        updateGraphics();
    }
}
