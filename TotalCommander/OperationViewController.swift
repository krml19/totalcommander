//
//  OperationViewController.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 27/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class OperationViewController: NSViewController {

    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet var progressTextField: NSTextField!
    @IBOutlet var dismissButton: NSButton!
    @IBAction func dismissAction(_ sender: Any) {
        tasks.forEach({
            $0.interrupt()
        })
        
        self.view.window?.close()
    }
    
    // tasks needs to be provided
    var tasks: [CopyTask]!
    fileprivate var fileProgress: FileProgressProvider!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureUI()
        configureData()
    }
    
    private func configureUI() {
        title = "menu_operation".localized()
        progressIndicator.doubleValue = 0.0
        dismissButton.title = "dismiss".localized()
        progressTextField.stringValue = "operation".localized() + String(tasks.count)
    }
    
    private func configureData() {
        guard tasks != nil, tasks.count != 0 else {
            self.view.window?.close()
            return
        }
        
        tasks.forEach({
            $0.launch()
        })
        
        fileProgress = FileProgressProvider(tasks: tasks, onProgress: { [weak self] doubleValue -> Void? in
            self?.progressIndicator.doubleValue = doubleValue
            if Double.minimum(doubleValue, 1.0) == 1.0 {
                self?.view.window?.close()
            }
            return ()
        })
        
        fileProgress.start()
        
    }
}
