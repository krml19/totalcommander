//
//  CommanderViewContoller+Watch.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit
/** Watch Extends CommanderViewContoller

*/
extension CommanderViewController: DispatchFileSystemWatcherDelegate {
    
    func fsWatcherDidObserveRename(_ watch: DispatchFileSystemWatcher) {
        log.debug(watch.path.fileName)
    }
    
    func fsWatcherDidObserveExtend(_ watch: DispatchFileSystemWatcher) {
        log.debug(watch.path.fileSize?.description ?? "No content.")
    }
}

// localize
extension CommanderViewController {
    @objc func langugeDidChange() {
        self.tableView.reloadData()
        self.nameColumn.title = "menu_column_name".localized()
        self.modificationDateColumn.title = "menu_column_date".localized()
        self.sizeColumn.title = "menu_column_size".localized()
    }
}
