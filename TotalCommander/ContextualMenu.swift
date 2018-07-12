//
//  NSMenu.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 25/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import RxGesture
import RxCocoa
import RxSwift

class ContextualMenu: NSMenu {
    
    func prepare(_ isSthSelected: Bool) {
        copyItem.isEnabled = isSthSelected
        deleteItem.isEnabled = isSthSelected
        let pasteboardIsNotempty = NSPasteboard.general().pasteboardItems != nil
        moveItem.isEnabled = pasteboardIsNotempty
        pasteItem.isEnabled = pasteboardIsNotempty
    }
    
    var subject: PublishSubject<Task.TaskType> = PublishSubject<Task.TaskType>()
    
    @IBOutlet var copyItem: NSMenuItem! {
        didSet {
            copyItem.title = "menu_contextual_copy".localized()
        }
    }
    @IBOutlet var pasteItem: NSMenuItem! {
        didSet {
            pasteItem.title = "menu_contextual_paste".localized()
        }
    }
    @IBOutlet var deleteItem: NSMenuItem! {
        didSet {
            deleteItem.title = "menu_contextual_delete".localized()
        }
    }
    @IBOutlet var moveItem: NSMenuItem! {
        didSet {
            moveItem.title = "menu_contextual_move".localized()
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        subject.onNext(.copy)
    }
    
    @IBAction func pasteAction(_ sender: Any) {
        subject.onNext(.paste)
    }

    @IBAction func deleteAction(_ sender: Any) {
        subject.onNext(.remove)
    }
    @IBAction func moveAction(_ sender: Any) {
        subject.onNext(.move)
    }
}
