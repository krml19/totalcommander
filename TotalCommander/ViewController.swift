//
//  ViewController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 10/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import Localize_Swift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var languageButton: NSButton!

    @IBAction func languageChanged(_ sender: Any) {
        Localize.currentLanguage() == "en" ? Localize.setCurrentLanguage("pl-PL") : Localize.setCurrentLanguage("en")
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func setText() {
        languageButton.title = "button".localized()
    }

}

