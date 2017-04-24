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
    var progressProvider: FileProgressProvider!
    
    var dispatchFileSystemWatcher: DispatchFileSystemWatcher!
    var fileSystemWatcher: FileSystemWatcher!

    var path: Path! = Path() {
        didSet {
            pathControl.url = path.url
            items = path.sorted(by: tableView.sortDescriptors.first)
            
            fileSystemWatcher = path.watch(0.5, queue: DispatchQueue.global(qos: .userInteractive)) { fileSystemEvent in
                log.info(fileSystemEvent.path.fileSize ?? "--")
            }
        }
    }
    var items: [Path]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(forDraggedTypes: [NSURLPboardType])
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
        if let url = pathControl.clickedPathItem?.url {
            path = Path(url: url)
        }
    }
    
    func tableViewDoubleClick(_ tableView: NSTableView) {
        guard tableView.selectedRow >= 0 else { return }
        
//        let selectedPath = items?[tableView.selectedRow]
        
//        if (selectedPath?.isDirectory)! {
//            path = selectedPath
//        } else {
//            let src = Path("/Volumes/SanDisk/Archive.zip")
//            let dst = Path("/Users/marcinkarmelita/Desktop/Archive.zip")
//            
//            DispatchQueue.global().async {
//                src.copy(dst)
//            }
//            
//            progressProvider = FileProgressProvider(src, dst: dst, delegate: self)
//        }
        
        copyTask()
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
        
        guard let item = items?[row] else {
            return nil
        }
        
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
            text = item.isDirectory ? Formatter.Size.Empty : String(describing: item.fileSize!) + "loc_bytes".localized()
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
        func updateStatus() {
            statusLabel.stringValue = String(tableView.numberOfSelectedRows)
        }
        
        updateStatus()
    }
    
}

extension CommanderViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        items = path.sorted(by: tableView.sortDescriptors.first)
    }
}

extension CommanderViewController: ProgressProvider {
    func onProgress(_ progress: Double) {
        log.debug("Progress: \(progress)")
    }
    
    func onDone() {
        log.debug("Done")
    }
    
    func onStart() {
        
    }
}

// drag
extension CommanderViewController {
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        log.debug(row)
        if let size = items?.count, size >= row {
            return true
        }
        
        return items?[row].isDirectory == true
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        log.info(dropOperation)
        
        if let size = items?.count, size >= row {
            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.regular
            return .move
        }
        
        if let item = items?[row], item.isDirectory {
            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.regular
        } else {
            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.none
        }
        
        return NSDragOperation.move
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        log.debug("Ended at")
        
    }
    
    func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        let pasteboard = draggingInfo.draggingPasteboard()
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            log.info(urls)
        }
    }
    
    func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
        log.debug("Did drag")
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
        log.debug("willBeginAt")
    }
    
}

// operations on files
extension CommanderViewController {
    func copyTask() {
        let task = Task(.copy)
        
        let src = Path("/Users/marcinkarmelita/Desktop/Archive.zip")
        let dst = Path("/Users/marcinkarmelita/Desktop/Archive_copy.zip")
        
        task.configure(arguments: [src.rawValue, dst.rawValue])
        task.terminationHandler = {
            log.verbose($0.terminationReason)
        }
        
        task.run()
    }
}
