//
//  TableView.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 25/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class TableView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(with event: NSEvent) {
        log.debug(event)
        
        super.mouseDown(with: event)
    }
    
}
