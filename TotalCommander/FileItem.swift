//
//  FileItem.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 24/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import FileKit
import DateToolsSwift

class FileItem: NSObject {
    public private(set) var path: Path
    var hideProgress: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    var progressValue: BehaviorSubject<Double> = BehaviorSubject<Double>(value: 0.0)
    
    init(_ path: Path) {
        self.path = path
    }
    
    var size: String {
        if path.isDirectory {
            return "--"
        }
        if let size = path.fileSize {
            return String(size) +  "loc_bytes".localized()
        }
        return "--"
        
    }
    var filename: String {
        return path.fileName
    }
    
    var url: URL {
        return path.url
    }
    
    var modificationDate: String {
        return DateFormatter.localizedString(from: path.modificationDate ?? path.creationDate ?? Date(), dateStyle: .medium, timeStyle: .medium)
    }
    
    var image: NSImage? {
        do {
            let values = try path.url.resourceValues(forKeys: [URLResourceKey.effectiveIconKey, URLResourceKey.customIconKey])
            return values.customIcon ?? values.effectiveIcon as? NSImage
        } catch  {
            log.error(error)
            return nil
        }
    }
}

