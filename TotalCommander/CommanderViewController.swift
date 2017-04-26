//
//  CommanderViewController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 19/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit
import RxSwift
import RxCocoa
import RxGesture

class CommanderViewController: NSViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var contextualMenu: ContextualMenu! {
        didSet {
            contextualMenu.subject.asObservable()
            .subscribe(onNext: { [unowned self] taskType in
                switch taskType {
                case .copy:
                    return self.copyTask()
                case .move:
                    return self.moveTask()
                case .paste:
                    return self.pasteTask()
                case .remove:
                    return self.deleteTask()
                default:
                    return
                }
            }).addDisposableTo(disposeBag)
        }
    }
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var pathControl: NSPathControl! {
        didSet {
            pathControl.isEditable = true
        }
    }
    
    var dispatchFileSystemWatcher: DispatchFileSystemWatcher!
    var fileSystemWatcher: FileSystemWatcher!
    
    var path: Path! = Path() {
        didSet {
            pathControl.url = path.url
            items = path.sorted(by: tableView.sortDescriptors.first).map({ (path) -> FileItem in
                return FileItem(path)
            })
            
            fileSystemWatcher = path.watch(0.5, queue: DispatchQueue.global(qos: .background)) { fileSystemEvent in
                log.info(fileSystemEvent.path.fileSize ?? "--")
                DispatchQueue.main.async(execute: { 
                    self.items = self.path.sorted(by: self.tableView.sortDescriptors.first).map({ (path) -> FileItem in
                        return FileItem(path)
                    })
                })
            }
        }
    }
    var items: [FileItem]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tableView.register(forDraggedTypes: [NSURLPboardType])
        tableView.target = self
        pathControl.action = #selector(pathControlAction(_:))
        path = Path(url: pathControl.url!)
        let nib = NSNib(nibNamed: "SizeCell", bundle: nil)
        tableView.register(nib, forIdentifier: "SizeCellID")
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        tableView.rx.rightClickGesture().filter({ (click) -> Bool in
            return click.state == NSGestureRecognizerState.ended
        }).subscribe(onNext: { click in
            if let menu = self.tableView.menu as? ContextualMenu {
                (self.tableView.menu as? ContextualMenu)!.prepare(self.tableView.selectedRowIndexes.count > 0)
                NSMenu.popUpContextMenu(menu, with: NSEvent(), for: self.tableView)
            }
        }).addDisposableTo(DisposeBag())
        
        for item in 0...2 {
            tableView.tableColumns[item].sortDescriptorPrototype = NSSortDescriptor(key: SortingOptions.indexOf(index: item).rawValue, ascending: true)
        }
    }
    
    override var representedObject: Any? {
        didSet {
            if let url = representedObject as? URL {
                path = Path(url: url)
            }
        }
    }
    
    func pathControlAction(_ pathControl: NSPathControl) {
        if let url = pathControl.clickedPathItem?.url {
            path = Path(url: url)
        }
    }
    
    func tableViewDoubleClick(_ tableView: NSTableView) {
        guard tableView.selectedRow >= 0 else { return }
        
        guard let selectedPath = items?[tableView.selectedRow] else {
            return
        }
        
        switch selectedPath.path.type {
        case .directory:
            path = selectedPath.path
            break
        case .app, .file:
            NSWorkspace.shared().openFile(selectedPath.path.rawValue)
            break
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
        
        guard let item = items?[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.filename
            image = item.image
            cellIdentifier = CellIdentifiers.NameCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.modificationDate
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.size
            cellIdentifier = CellIdentifiers.SizeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            
            if cell is SizeCell {
                (cell as! SizeCell).configure(item)
            }
            
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
        items = path.sorted(by: tableView.sortDescriptors.first).map({ path -> FileItem in
            return FileItem(path)
        })
    }
}

// drag
//extension CommanderViewController {
//    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
//        log.debug(row)
//        if let size = items?.count, size >= row {
//            return true
//        }
//        
//        return items?[row].isDirectory == true
//    }
//    
//    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
//        log.info(dropOperation)
//        
//        if let size = items?.count, size >= row {
//            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.regular
//            return .move
//        }
//        
//        if let item = items?[row], item.isDirectory {
//            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.regular
//        } else {
//            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.none
//        }
//        
//        return NSDragOperation.move
//    }
//    
//    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
//        log.debug("Ended at")
//        
//    }
//    
//    func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
//        let pasteboard = draggingInfo.draggingPasteboard()
//        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
//            log.info(urls)
//        }
//    }
//    
//    func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
//        log.debug("Did drag")
//    }
//    
//    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
//        log.debug("willBeginAt")
//    }
//    
//}

// operations on files
extension CommanderViewController {
    func pasteTask() {
        guard let urls = (NSPasteboard.general().readObjects(forClasses: [NSURL.self], options: nil)) as? [URL] else {
            log.error("Cannot read from pasteboard")
            return
        }
        
        urls.forEach { url in
            CopyTask(Path(url: url)!, to: self.path + url.lastPathComponent , terminationHandler: { process in
                log.debug(process.terminationReason)
                log.debug(process.terminationStatus)
            }).launch()
        }
    }
    
    func moveTask() {
        let task = Task(.move)
        
        let src = Path("/Users/marcinkarmelita/Desktop/Archive.zip")
        let dst = Path("/Users/marcinkarmelita/Desktop/Archive_copy.zip")
        
        task.configure(arguments: [src.rawValue, dst.rawValue])
        task.terminationHandler = { process in
            DispatchQueue.main.async(execute: {
                log.debug(process.terminationReason)
                log.debug(process.terminationStatus)
            })
        }
        
        task.run()
    }
    
    func copyTask() {
        let pasteboard = NSPasteboard.general()
        pasteboard.clearContents()
        let files: [URL] = tableView.selectedRowIndexes.map { (index) -> URL in
            return self.items![index].path.url
        }
        
        pasteboard.writeObjects(files as [NSPasteboardWriting])
    }
    
    func deleteTask() {
        let files: [Path] = tableView.selectedRowIndexes.map { (index) -> Path in
            return self.items![index].path
        }
        guard files.count != 0 else {
            return
        }
        
        guard AlertController.deleteFile() else {
            return
        }
        
        files.forEach({
            $0.delete()
        })
        
    }
}
