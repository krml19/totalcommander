//: Playground - noun: a place where people can play

import Cocoa
import FileKit

var str = "Hello, playground"

//let path = Path("/Users/marcinkarmelita/Desktop/mag_nor/i.dmg")
let path = Path("/Users/marcinkarmelita/Downloads/ideaIC-2017.1.dmg")

func getInfo(path: Path) {
    path.isDirectory
    path.isAny
    path.isDirectoryFile
    path.isWritable
    path.isDeletable
    path.isAbsolute
    path.isRoot
    path.isExecutable
}

getInfo(path: path)
let parent = Path("/Users/marcinkarmelita/Desktop/i.dmg")

do {
    try path.moveFile(to: parent)
} catch {
    error
}
path.filePermissions
path.posixPermissions
path.components.count

var executed = false

func progress(_ destination: Path) {
    let userInfo: [ProgressUserInfoKey: Any] = [
        ProgressUserInfoKey.fileOperationKindKey: Progress.FileOperationKind.copying,
        ProgressUserInfoKey.fileURLKey: destination.url
    ]
    
    let progress = Progress(parent: nil, userInfo: userInfo)
    progress.isCancellable = true
    progress.kind = .file
    progress.totalUnitCount = 10
    progress.publish()
}


let manager = FileManager.default
do {
    if !executed {
        path.url
        parent.url
        progress(parent)
        try manager.copyItem(at: path.url, to: parent.url)
    }
    
    executed = true
} catch {
    error
}

