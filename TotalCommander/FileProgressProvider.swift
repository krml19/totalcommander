//
//  FileProgressProvider.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit

typealias ProgressHandler = ((Double) -> Void?)

open class FileProgressProvider {

    fileprivate var progressHandler: ProgressHandler?
    fileprivate var timeInterval: TimeInterval
    fileprivate var tasks: [CopyTask]
    fileprivate lazy var timer: Timer = {
       let timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(FileProgressProvider.tick), userInfo: nil, repeats: true)
        return timer
    }()
    
    public func start() {
        timer.fire()
    }
    
    public func stop() {
        progressHandler?(1.0)
        timer.invalidate()
    }
    
    init(_ timeInterval: TimeInterval = 0.25, tasks: [CopyTask], onProgress: ProgressHandler? = nil) {
        self.timeInterval = timeInterval
        self.tasks = tasks
        self.progressHandler = onProgress
    }
    
    @objc fileprivate func tick() {
        progressHandler?(calculateOverallProgress)
    }
    
    private var calculateOverallProgress: Double {
        guard tasks.filter({
            !$0.isFinished
        }).first != nil else {
            return 1.0
        }

        var overallProgress: Double = 0.0
        tasks.forEach({
            overallProgress += $0.progress
        })
        guard tasks.count > 0 else {
            return 1.0
        }
        
        overallProgress /= Double(tasks.count)
        log.debug("Overall Progess: \(overallProgress * 100.0)")
        return overallProgress * 100.0
    }
}
