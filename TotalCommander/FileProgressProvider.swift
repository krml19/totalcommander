//
//  FileProgressProvider.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit

typealias StartHandler = ((Void) -> Void?)
typealias EndHandler = ((Void) -> Void?)
typealias ProgressHandler = ((Double) -> Void?)

open class FileProgressProvider {
    fileprivate var srcSize: UInt64
    fileprivate var dst: Path
    fileprivate var startHandler: StartHandler?
    fileprivate var progressHandler: ProgressHandler?
    fileprivate var endHandler: EndHandler?
    
    fileprivate lazy var timer: Timer = {
       let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(FileProgressProvider.tick), userInfo: nil, repeats: true)
        return timer
    }()
    
    public func start() {
        timer.fire()
        startHandler?()
    }
    
    public func stop() {
        timer.invalidate()
        endHandler?()
    }
    
    init(_ src: Path, dst: Path, onStart: StartHandler? = nil, onProgress: ProgressHandler? = nil, onEnd: EndHandler? = nil) {
        self.srcSize = src.fileSize ?? 0
        self.dst = dst
        
        startHandler = onStart
        progressHandler = onProgress
        endHandler = onEnd
    }
    
    @objc fileprivate func tick() {
        progressHandler?(calculateProgress())
    }
    
    private func calculateProgress() -> Double {
        guard let dstSize = dst.fileSize, srcSize != 0 else {
            return 0.0
        }
        let result: Double = Double(dstSize) / Double(srcSize)
        
        log.info("Progress (\(result)): \(dstSize) / \(srcSize)")
        return Double.minimum(result, 1)
    }
}
