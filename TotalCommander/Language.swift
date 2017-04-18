//
//  Language.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import Localize_Swift

protocol Language {
    
    var pl: String { get }
    var en: String { get }
}

protocol LocalizedDelegate {
    func langugeDidChange()
}

class Localizable: Language {
    
    required init(_ object: LocalizedDelegate) {
        delegate = object
        setupNotification()
    }
    
    var delegate: LocalizedDelegate?
    
    func changeLanguage() {
        Localize.currentLanguage() == en ? Localize.setCurrentLanguage(pl) : Localize.setCurrentLanguage(en)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
    }
    
    @objc private func languageChanged() {
        delegate?.langugeDidChange()
    }
}

extension Language {
    
    var pl: String {
        return "pl-PL"
    }
    
    var en: String {
        return "en"
    }
}
