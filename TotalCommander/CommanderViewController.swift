//
//  CommanderViewController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 19/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit

class CommanderViewController: ViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var pathControl: NSPathControl! {
        didSet {
            pathControl.isEditable = true
        }
    }

    var path: Path! = Path() {
        didSet {
            pathControl.url = path.url
            items = path.sorted(by: tableView.sortDescriptors.first)
        }
    }
    var items: [Path]! = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.target = self
        pathControl.action = #selector(pathControlAction(_:))
        path = Path(url: pathControl.url!)
        
        
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        for item in 0...2 {
            tableView.tableColumns[item].sortDescriptorPrototype = NSSortDescriptor(key: Path.SortingOptions.indexOf(index: item).rawValue, ascending: true)
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    func pathControlAction(_ pathControl: NSPathControl) {
        log.info(pathControl.clickedPathItem!)
        log.info(pathControl.clickedPathComponentCell()!)
        log.info(pathControl.pathItems)
        
        if let url = pathControl.clickedPathItem?.url {
            path = Path(url: url)
        }
    }
    
    func tableViewDoubleClick(_ tableView: NSTableView) {
        guard tableView.selectedRow >= 0 else { return }
        
        let selectedPath = items[tableView.selectedRow]
        if selectedPath.isDirectory {
            path = selectedPath
        }
    }
}



extension CommanderViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let DateCell = "DateCellID"
        static let SizeCell = "SizeCellID"
    }
    
    fileprivate enum Formatter {
        enum Size {
            static let Empty = "--"
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        let item = items[row]
        
        if tableColumn == tableView.tableColumns[0] {
            do {
                let values = try item.url.resourceValues(forKeys: [URLResourceKey.effectiveIconKey, URLResourceKey.customIconKey])
                image = values.customIcon ?? values.effectiveIcon as? NSImage
            } catch  {
                log.error(error)
            }
            
            text = item.fileName
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = dateFormatter.string(from: item.modificationDate ?? item.creationDate ?? Date())
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.isDirectory ? Formatter.Size.Empty : String(describing: item.fileSize!) + " bytes".localized()
            cellIdentifier = CellIdentifiers.SizeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        updateStatus()
    }

}

extension CommanderViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        items = path.sorted(by: tableView.sortDescriptors.first)
    }
}
