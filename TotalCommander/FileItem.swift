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

class FileItem: NSObject {
    private var path: Path
    var hideProgress: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    var progressValue: BehaviorSubject<Double> = BehaviorSubject<Double>(value: 0.0)
    
    init(_ path: Path) {
        self.path = path
    }
    
    var size: String {
        return path.isDirectory ? "--" : String(describing: path.fileSize!) + "loc_bytes".localized()
    }
    var filename: String {
        return path.fileName
    }
    
    var url: URL {
        return path.url
    }
    
    var modificationDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: path.modificationDate ?? path.creationDate ?? Date())
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
