//
//  AppDelegate.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 10/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import Localize_Swift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    fileprivate var localizable: Localizable!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        setup()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setup() {
        localizable = Localizable(self)
        
        let menu = MainMenu(title: "File")
        NSApp.mainMenu = menu
    }
}

extension AppDelegate: LocalizedDelegate {
    func langugeDidChange() {
        MainMenu.updateLanguage(menu: NSApp.mainMenu!)
    }
}
