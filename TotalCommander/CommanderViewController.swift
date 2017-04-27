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
import Localize_Swift

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
    @IBOutlet var nameColumn: NSTableColumn!
    @IBOutlet var modificationDateColumn: NSTableColumn!
    @IBOutlet var sizeColumn: NSTableColumn!
    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var pathControl: NSPathControl! {
        didSet {
            pathControl.isEditable = true
            pathControl.doubleAction = #selector(pathControlDoubleClick(_:))
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
        NotificationCenter.default.addObserver(self, selector: #selector(langugeDidChange),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        
        
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
                self.contextualMenu.prepare(self.tableView.selectedRowIndexes.count > 0)
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
    
    func pathControlDoubleClick(_ pathControl: NSPathControl) {
        guard let window = NSApp.mainWindow else { return }
        let openPanel = NSOpenPanel()
        openPanel.showsHiddenFiles = true
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        
        openPanel.beginSheetModal(for: window) { response in
            guard response == NSFileHandlingPanelOKButton else {
                return
            }
            if let url = openPanel.url {
               self.path = Path(url: url)
            }
            
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
extension CommanderViewController {
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        log.debug(row)
        if let size = items?.count, size >= row {
            return true
        }
        
        return items?[row].path.isDirectory == true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        log.info(dropOperation)
        
        if let size = items?.count, size >= row {
            tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyle.regular
            return .move
        }
        
        if let item = items?[row], item.path.isDirectory {
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
            var tasks = [CopyTask]()
            
            urls.forEach { url in
                tasks.append(CopyTask(Path(url: url)!, to: self.path + url.lastPathComponent, type: .move, terminationHandler: { process in
                    log.debug(process.terminationReason)
                    log.debug(process.terminationStatus)
                }))
            }
            
            self.performSegue(withIdentifier: "ModalOperation", sender: tasks)
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
    func pasteTask(type: Task.TaskType = .copy) {
        guard let urls = (NSPasteboard.general().readObjects(forClasses: [NSURL.self], options: nil)) as? [URL] else {
            log.error("Cannot read from pasteboard")
            return
        }
        
        var tasks = [CopyTask]()
        
        urls.forEach { url in
            tasks.append(CopyTask(Path(url: url)!, to: self.path + url.lastPathComponent, type: type, terminationHandler: { process in
                log.debug(process.terminationReason)
                log.debug(process.terminationStatus)
            }))
        }
        
        self.performSegue(withIdentifier: "ModalOperation", sender: tasks)
    }
    
    func moveTask() {
        pasteTask(type: .move)
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
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalOperation", let vc = segue.destinationController as? OperationViewController, let tasks = sender as? [CopyTask] {
            vc.tasks = tasks
        }
    }
    
}
