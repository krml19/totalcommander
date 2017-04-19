//
//  AppDelegate.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 10/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import Localize_Swift
import SwiftyBeaver

let log = SwiftyBeaver.self

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
    
    @IBAction func chanlang(_ sender: Any) {
        Localizable.toggleLanguage()
    }
    func setup() {
        // language
        localizable = Localizable(self)
        
        // menu
//        let menu = MainMenu(title: "File")
//        NSApp.mainMenu = menu
        
        //swifty beaver
        log.addDestination(ConsoleDestination())
    }
}

extension AppDelegate: LocalizedDelegate {
    func langugeDidChange() {
        MainMenu.updateLanguage(menu: NSApp.mainMenu!)
    }
}
