//
//  MainMenu.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {
    
    
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
    
    private func createItem(_ title: String, action: Selector?) -> NSMenuItem {
        let item = NSMenuItem(title: title.localized(), action: action, keyEquivalent: title)
        item.identifier = title
        item.toolTip = (item.identifier! + "_tooltip").localized()
        item.isEnabled = true
        return item
    }
    
    private func language() {
        let item = createItem("menu_lang", action: nil)
        self.addItem(item)
        let menu = NSMenu(title: "menu_lang".localized())
        setSubmenu(menu, for: item)
        
        var polishSelector: Selector? {
            Localizable.set(language: Localizable.Language.pl)
            return nil
        }
        
        var englishSelector: Selector? {
            Localizable.set(language: Localizable.Language.en)
            return nil
        }
        
        menu.addItem(createItem("menu_lang_en", action: polishSelector))
        menu.addItem(createItem("menu_lang_pl", action: englishSelector))
    }
    
    private func help() {
        let item = NSMenuItem(title: "menu_help".localized(), action: nil, keyEquivalent: "menu_help")
        item.identifier = "menu_help"
        item.toolTip = (item.identifier! + "_tooltip").localized()
        self.addItem(item)
        let menu = NSMenu(title: "menu_help".localized())
        setSubmenu(menu, for: item)
    }

    private func prepareMenu() {
        app()
        file()
        edit()
        language()
        help()
    }
}

// MARK: - Class methods
extension MainMenu {
    
    public class func updateLanguage(menu: NSMenu) {
        
//        log.debug(menu.identifier)
        
        menu.items.forEach({ item in
            item.title = item.identifier?.localized() ?? "None"
            log.info(item.toolTip)
            
            log.debug(item.accessibilityIdentifier())
            
            if item.hasSubmenu {
                if item.identifier != nil {
                    
                }
                
                log.error(item.identifier)
                updateLanguage(menu: item.submenu!)
            }
        })
    }
}
