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
    
    private let from: Path
    private let to: Path
    private var fileProgressProvider: FileProgressProvider?
    
    init(_ from: Path, to: Path, terminationHandler: TerminationHandler) {
        self.to = to
        self.from = from
        super.init(.copy)
        self.terminationHandler = terminationHandler
        setup()
    }
    
    fileprivate func setup() {
        configure(arguments: [from.rawValue, to.rawValue])
    }
    
    func addProgress(onStart: StartHandler? = nil, onProgress: ProgressHandler? = nil, onEnd: EndHandler? = nil) -> CopyTask {
        fileProgressProvider = FileProgressProvider(self.from, dst: self.to, onStart: onStart, onProgress: onProgress, onEnd: onEnd)
        return self
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
    
    override func interrupt() {
        super.interrupt()
        fileProgressProvider?.stop()
    }
    
    override func run() {
        super.run()
        fileProgressProvider?.start()
    }
    
    override func done() {
        super.done()
        fileProgressProvider?.stop()
    }
}
