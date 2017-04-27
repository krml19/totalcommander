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
        self.window?.title = "Total Commander"
        
    }
    
    @IBAction func polish(_ sender: AnyObject?) {
        Localizable.set(language: .pl)
    }
    
    @IBAction func english(_ sender: AnyObject?) {
        Localizable.set(language: .en)
    }
}
