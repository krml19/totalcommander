//
//  CopyTask.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 24/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit

class CopyTask: Task {
    // class for copy or move operations
    
    private let from: Path
    private let to: Path
    
    var progress: Double {
        guard let dstSize = to.fileSize, let srcSize = from.fileSize else {
            return 0.0
        }
        let result: Double = Double(dstSize) / Double(srcSize)
        log.debug("CopyTask Progess: \(result)")
        return Double.minimum(result, 1)
    }
    
    init(_ from: Path, to: Path, type: TaskType = .copy, terminationHandler: TerminationHandler) {
        self.to = to
        self.from = from
        super.init(type)
        self.terminationHandler = terminationHandler
        setup()
    }
    
    fileprivate func setup() {
        configure(arguments: [from.rawValue, to.rawValue])
    }
    
    func launch() {
        if to.exists {
            if AlertController.overrideFile() {
                run()
            }
        } else {
            run()
        }
    }
}
