//
//  Language.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import Localize_Swift

protocol LocalizedDelegate {
    func langugeDidChange()
}

class Localizable {
    
    enum Language: String {
        case pl = "pl-PL"
        case en = "en"
    }
    
    class func set(language: Language) {
        Localize.setCurrentLanguage(language.rawValue)
    }
    
    class func toggleLanguage() {
        Localize.currentLanguage() == Language.pl.rawValue ? set(language: .en) : set(language: .pl)
    }
    
    required init(_ object: LocalizedDelegate) {
        delegate = object
        setupNotification()
    }
    
    
    var delegate: LocalizedDelegate?
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
    }
    
    @objc private func languageChanged() {
        delegate?.langugeDidChange()
    }
}
