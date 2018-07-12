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
    
    // language menu
    @IBOutlet weak var polish: NSMenuItem!
    @IBOutlet weak var english: NSMenuItem!
    @IBOutlet weak var language_menu: NSMenu!
    
    // total commander menu
    @IBOutlet weak var about: NSMenuItem!
    @IBOutlet weak var hide: NSMenuItem!
    @IBOutlet weak var hide_others: NSMenuItem!
    @IBOutlet weak var show: NSMenuItem!
    @IBOutlet weak var quit: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        setup()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    @IBAction func chanlang(_ sender: Any) {
        Localizable.toggleLanguage()
    }
    func setup() {
        //swifty beaver
        log.addDestination(ConsoleDestination())
        NotificationCenter.default.addObserver(self, selector: #selector(langugeDidChange),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        Localizable.set(language: .en)
        
        NSApp.mainWindow?.title = "Total Commander"
    }
}

extension AppDelegate: LocalizedDelegate {
    @objc func langugeDidChange() {
        
        // language
        language_menu.title = "menu_language".localized()
        polish.title = "menu_language_polish".localized()
        english.title = "menu_language_english".localized()
        
        let isPolish = Localizable.currentLanguage() == Language.pl
        polish.state = isPolish ? 1 : 0
        english.state = isPolish ? 0 : 1
        
        // about
        about.title = "menu_tc_about".localized()
        hide.title = "menu_tc_hide".localized()
        hide_others.title = "menu_tc_hide_others".localized()
        show.title = "menu_tc_show".localized()
        quit.title = "menu_tc_quit".localized()
        
        
    }
}
