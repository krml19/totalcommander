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
    
    @IBAction func polish(_ sender: AnyObject?) {
        Localizable.set(language: .pl)
    }
    
    @IBAction func english(_ sender: AnyObject?) {
        Localizable.set(language: .en)
    }
}
