//
//  ViewController.swift
//  dbSync
//
//  Created by Kalle Hansson on 2017-07-30.
//  Copyright © 2017 SchlagerKhan. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ViewController: NSViewController {
    @IBOutlet weak var groupNameLabel: NSTextField!
    
    @IBOutlet weak var allDatabasesTable: NSTableView!

    @IBOutlet weak var fromDatabaseDropdown: NSPopUpButton!
    @IBOutlet weak var fromTablesTable: NSScrollView!
    @IBOutlet weak var toDatabasesTable: NSScrollView!
    
    @IBOutlet weak var syncBtn: NSButton!
    @IBOutlet weak var serverResponseTextbox: NSTextField!
    
    let settings = Settings();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTables();

        updateGraphics();
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func initTables() {
        allDatabasesTable.dataSource = self;
        allDatabasesTable.delegate = self;
    }
    
    func loadDatabases() {
        
    }
    
    func updateGraphics() {
        let currentGroup = settings.getCurrentGroup();
        
        if (currentGroup == JSON.null) {
            groupNameLabel.stringValue = "No group chosen";
        } else {
            groupNameLabel.stringValue = currentGroup["name"].stringValue;
        }
    }
    
    @IBAction func openConfigModal(_ sender: Any) {}
    @IBAction func addDatabase(_ sender: Any) {}
    @IBAction func deleteDatabase(_ sender: Any) {}
    
    @IBAction func syncDatabases(_ sender: Any) {}
}

extension ViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let currentGroup = settings.getCurrentGroup();
        return currentGroup["databases"].count;
    }
}
extension ViewController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let currentGroup = settings.getCurrentGroup();
        let databases = currentGroup["databases"];
        let item = databases[row];
        
        if let cell = tableView.make(withIdentifier: "CellID", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = item["name"].stringValue;
            return cell;
        }
        
        return nil;
    }
}

