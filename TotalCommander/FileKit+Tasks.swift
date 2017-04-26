//
//  FileKit+Tasks.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit
/** Tasks Extends FileKit

*/
extension Path {
    
    func move(_ to: Path) {
        do {
            try moveFile(to: to)
        } catch {
            log.error(error)
            AlertController.errorOccurred(error)
        }
    }
    
    func copy(_ to: Path) {
        do {
            try copyFile(to: to)
            
        } catch {
            log.error(error)
            AlertController.errorOccurred(error)
        }
    }
    
    func delete() {
        do {
            try deleteFile()
        } catch {
            
            AlertController.errorOccurred(error)
            log.error("File cannot be deleted.")
        }
    }    
}
