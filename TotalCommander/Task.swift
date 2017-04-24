//
//  Task.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 17/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Cocoa

class Task: NSObject {
    enum TaskType: String {
        case copy = "copy"
        case remove = "remove"
        case paste = "paste"
        case create = "create"
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
    
    required init(_ type: TaskType) {
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
                print("Unable to locate \(self.type.rawValue).command")
                return
            }
            
            self.process = Process()
            self.process.launchPath = path
            self.process.arguments = self.arguments
            
            self.terminationHandler = self.process.terminationHandler
            self.process.launch()
            self.process.waitUntilExit()
        }
    }
}
