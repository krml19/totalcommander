//
//  AlertController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class AlertController {
    
    class func alert(message: String, informativeText: String, buttonTitles: [String] = ["OK"]) -> NSAlert {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = informativeText
        buttonTitles.forEach({
            alert.addButton(withTitle: $0)
        })
        alert.alertStyle = .warning
        return alert
    }
    
    class func dialogOKCancel(question: String, text: String) -> Bool {
        return AlertController.alert(message: question, informativeText: text, buttonTitles: ["OK".localized(), "Cancel".localized()])
        .runModal() == NSAlertFirstButtonReturn
    }
    
    class func overrideFile() -> Bool {
        return dialogOKCancel(question: "alert_message_exists".localized(), text: "alert_text_exists".localized())
    }
    
    class func deleteFile() -> Bool {
        return dialogOKCancel(question: "alert_message_delete".localized(), text: "alert_text_delete".localized())
    }
    
    @discardableResult
    class func errorOccurred(_ error: Error) -> Bool {
        return AlertController.alert(message: "alert_error_occured".localized(), informativeText: error.localizedDescription, buttonTitles: ["OK".localized()])
            .runModal() == NSAlertFirstButtonReturn
    }
}
