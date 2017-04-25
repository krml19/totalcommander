//
//  NSMenu.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 25/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import RxGesture
import RxCocoa
import RxSwift

class ContextualMenu: NSMenu {
    
    @IBOutlet var copyItem: NSMenuItem! {
        didSet {
            copyItem.title = "menu_contextual_copy".localized()
        }
    }
    @IBOutlet var pasteItem: NSMenuItem! {
        didSet {
            pasteItem.title = "menu_contextual_paste".localized()
        }
    }
    @IBOutlet var deleteItem: NSMenuItem! {
        didSet {
            deleteItem.title = "menu_contextual_delete".localized()
        }
    }
    
    
    @IBAction func copyAction(_ sender: Any) {
        
    }
    
    @IBAction func pasteAction(_ sender: Any) {
        
    }

    @IBAction func deleteAction(_ sender: Any) {
        
    }
}
