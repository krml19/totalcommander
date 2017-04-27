//
//  Task.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

typealias TerminationHandler = ((Process) -> Swift.Void)?
open class Task: NSObject {
    
    public enum TaskType: String {
        case copy = "Copy"
        case remove = "Remove"
        case paste = "Paste"
        case create = "Create"
        case move = "Move"
    }
    
    let type: TaskType
    private var launchPath: String?
    private var arguments: [String]?
    private var process: Process!
    private var qos = DispatchQoS.QoSClass.background
    var isFinished: Bool = false
    
    dynamic var terminationHandler: TerminationHandler
    
    var isRunning: Bool {
        return process.isRunning
    }
    
    public init(_ type: TaskType) {
        self.type = type
    }
    
    func configure(_ path: String? = nil, arguments:[String]? = nil) {
        self.launchPath = path
        self.arguments = arguments
    }
    
    func interrupt() {
        if process.isRunning {
            self.process.interrupt()
        }
    }
    
    func runIf(_ condition: Bool) {
        if condition {
            run()
        }
    }
    
    dynamic func done() {
        
    }
    
    func run() {
        let taskQueue = DispatchQueue.global(qos: qos)
        
        taskQueue.async {
            guard let path = Bundle.main.path(forResource: self.type.rawValue ,ofType:"command") else {
                log.error("Unable to locate \(self.type.rawValue).command")
                return
            }
            
            self.process = Process()
            self.process.launchPath = path
            self.process.arguments = self.arguments

            self.process.terminationHandler = { [weak self] handler in
                log.info(handler.terminationStatus)
                
                DispatchQueue.main.async(execute: {
                    self?.isFinished = true
                    if self?.terminationHandler != nil {
                        self?.terminationHandler!(handler)
                        
                    }
                })
            }
            
            self.process.launch()
            self.process.waitUntilExit()
        }
    }
}
