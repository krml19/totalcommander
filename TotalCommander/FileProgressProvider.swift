//
//  FileProgressProvider.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 22/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa
import FileKit

public protocol ProgressProvider {
    func onProgress(_ progress: Double)
    func onDone()
    func onStart()
}

open class FileProgressProvider {
    fileprivate var srcSize: UInt64
    fileprivate var dst: Path
    fileprivate var delegate: ProgressProvider?
    
    fileprivate lazy var timer: Timer = {
       let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(FileProgressProvider.tick), userInfo: nil, repeats: true)
        return timer
    }()
    
    public func start() {
        timer.fire()
        delegate?.onStart()
    }
    
    init(_ src: Path, dst: Path, delegate: ProgressProvider? = nil) {
        self.srcSize = src.fileSize ?? 0
        self.dst = dst
        self.delegate = delegate
    }
    
    @objc fileprivate func tick() {
        let progress = calculateProgress()
        if progress == 1.0 {
            delegate?.onDone()
            timer.invalidate()
        } else {
            delegate?.onProgress(progress)
        }
    }
    
    private func calculateProgress() -> Double {
        guard let dstSize = dst.fileSize, srcSize != 0 else {
//            timer.invalidate()
//            return 1.0
            return 0.0
        }
        let result: Double = Double(dstSize) / Double(srcSize)
        
        log.info("Progress (\(result)): \(srcSize) / \(dstSize)")
        return Double.minimum(result, 1)
    }
}
