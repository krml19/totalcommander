//
//  MainMenu.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        prepareMenu()
    }
    
    override init(title: String) {
        super.init(title: title)
        prepareMenu()
    }
    
    private func app() {
        let item = NSMenuItem(title: "menu_app".localized(), action: nil, keyEquivalent: "menu_app")
        item.identifier = "menu_app"
        item.toolTip = (item.identifier! + "_tooltip").localized()
        self.addItem(item)
        let menu = NSMenu(title: "menu_app".localized())
        
        setSubmenu(menu, for: item)
    }
    
    private func file() {
        let item = NSMenuItem(title: "menu_file".localized(), action: nil, keyEquivalent: "menu_file")
        item.identifier = "menu_file"
        item.toolTip = (item.identifier! + "_tooltip").localized()
        self.addItem(item)
        let menu = NSMenu(title: "menu_file".localized())
        setSubmenu(menu, for: item)
    }
    
    private func edit() {
        let item = NSMenuItem(title: "menu_edit".localized(), action: nil, keyEquivalent: "menu_edit")
        item.identifier = "menu_edit"
        item.toolTip = (item.identifier! + "_tooltip").localized()
        self.addItem(item)
        let menu = NSMenu(title: "menu_edit".localized())
        setSubmenu(menu, for: item)
    }
    
    private func help() {
        let item = NSMenuItem(title: "menu_help".localized(), action: nil, keyEquivalent: "menu_help")
        item.identifier = "menu_help"
        item.toolTip = (item.identifier! + "_tooltip").localized()
        self.addItem(item)
        let menu = NSMenu(title: "menu_help".localized())
        setSubmenu(menu, for: item)
    }

    func prepareMenu() {
        app()
        file()
        edit()
        help()
    }
}

extension MainMenu {
    
    public class func updateLanguage(menu: NSMenu) {

        menu.items.forEach({ item in
            
            if item.hasSubmenu {
                item.submenu!.title = item.identifier!.localized()
                updateLanguage(menu: item.submenu!)
            }
        })
    }
}
