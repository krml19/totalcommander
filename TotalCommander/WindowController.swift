//
//  WindowController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 25/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    @IBAction func openDocument(_ sender: AnyObject?) {
        
        let openPanel = NSOpenPanel()
        openPanel.showsHiddenFiles = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        
        openPanel.beginSheetModal(for: window!) { response in
            guard response == NSFileHandlingPanelOKButton else {
                return
            }
            self.contentViewController?.representedObject = openPanel.url
        }
    }
    
    @IBAction func copy(_ sender: AnyObject?) {
        
    }
    
    @IBAction func paste(_ sender: AnyObject?) {
        if let urls = NSPasteboard.general().readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            self.contentViewController?.representedObject = urls
        }
    }
    
    @IBAction func polish(_ sender: AnyObject?) {
        Localizable.set(language: .pl)
    }
    
    @IBAction func english(_ sender: AnyObject?) {
        Localizable.set(language: .en)
    }
}
