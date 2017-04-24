//
//  Task.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

open class Task: NSObject {
    public enum TaskType: String {
        case copy = "Copy"
        case remove = "Remove"
        case paste = "Paste"
        case create = "Create"
    }
    
    let type: TaskType
    private var launchPath: String?
    private var arguments: [String]?
    private var process: Process!
    private var qos = DispatchQoS.QoSClass.background
    
    open var terminationHandler: ((Process) -> Swift.Void)?
    
    dynamic var isRunning: Bool {
        return process.isRunning
    }
    
    required public init(_ type: TaskType) {
        self.type = type
    }
    
    func configure(_ path: String? = nil, arguments:[String]? = nil) {
        self.launchPath = path
        self.arguments = arguments
    }
    
    func interrupt() {
        self.process.interrupt()
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
            
            self.terminationHandler = self.process.terminationHandler
            
            self.process.standardError = log.destinations.first
            self.process.standardInput = log.destinations.first
            self.process.standardOutput = log.destinations.first
            
            self.process.launch()
            self.process.waitUntilExit()
            
            
            
        }
    }
}
