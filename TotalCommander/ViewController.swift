//
//  ViewController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 10/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    fileprivate var localizable: Localizable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable = Localizable(self)

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var languageButton: NSButton!

    @IBAction func languageChanged(_ sender: Any) {
        localizable.changeLanguage()
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func setText() {
//        languageButton.title = "button".localized()
    }
}

extension ViewController: LocalizedDelegate {
    func langugeDidChange() {
        languageButton.title = "button".localized()
    }
    
}

