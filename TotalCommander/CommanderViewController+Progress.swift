//
//  CommanderViewController+Progress.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit
/** Progress Extends CommanderViewController

*/
extension CommanderViewController {
    
    func progress(_ destination: Path) {
        let userInfo: [ProgressUserInfoKey: Any] = [
            ProgressUserInfoKey.fileOperationKindKey: Progress.FileOperationKind.copying,
            ProgressUserInfoKey.fileURLKey: destination.url
        ]
        
        let progress = Progress(parent: nil, userInfo: userInfo)
        progress.isCancellable = true
        progress.kind = .file
        progress.totalUnitCount = 10
        progress.publish()
        
        let progressIndicator = NSProgressIndicator()
        
        
        
        
    }
}
