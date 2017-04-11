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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    dynamic var title = "TotalCommander".localized()
    
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var file: NSMenu!

    @IBOutlet weak var fileMenuItem: NSMenuItem!
}

extension AppDelegate {
    func setText() {
        mainMenu.title = "TotalCommander".localized()
        fileMenuItem.title = "TotalCommander".localized()
        file.title = "TotalCommander".localized()
    }
}
