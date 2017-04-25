//
//  FileKit+Handle.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 21/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit

/** Handle Extends FileKit
 
 */
extension Path {
    enum FileType {
        case file
        case app
        case directory
    }
    
    var type: FileType {
        do {
            let appKey = try url.resourceValues(forKeys: [URLResourceKey.isApplicationKey])
            if appKey.isApplication == true {
                return .app
            }
        } catch {
            log.error("URL Resources error.")
        }
        
        return self.isDirectory ? .directory : .file
    }
}
