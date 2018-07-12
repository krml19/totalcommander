//
//  FileKit+Sort.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 19/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit

protocol Sortable {
    associatedtype T
    func sorted(by sortDescriptor: NSSortDescriptor?) -> [T]
}

enum SortingOptions: String {
    case name
    case modificationDate
    case size
    
    static func indexOf(index: Int) -> SortingOptions {
        switch index {
        case 0:
            return .name
        case 1:
            return .modificationDate
        case 2:
            return .size
        default:
            return .name
        }
    }
}

extension Path: Sortable {
    var directories: [Path] {
        return children().filter({$0.isDirectory})
    }
    
    var files: [Path] {
        return children().filter({!$0.isDirectory})
    }
    
    func sorted(by sortDescriptor: NSSortDescriptor?) -> [Path] {
        guard let sortDescriptor = sortDescriptor else { return children() }
        let sortedChildren = sorted(by: sortDescriptor.key, ascending: sortDescriptor.ascending)
        var dirs = sortedChildren
            .filter({$0.isDirectory})
        dirs.append(contentsOf: sortedChildren.filter({!$0.isDirectory}))
        return dirs
    }
    
    private func sorted(by type: String?, ascending: Bool = true) -> [Path] {
        guard type != nil, let type = SortingOptions(rawValue: type!) else {
            return self.children()
        }
        switch type {
        case .name:
            return sorted({
                ($0.0.fileName.lowercased() < $0.1.fileName.lowercased()) == ascending
                
            })
        case .modificationDate:
            return sorted({
                ($0.0.modificationDate ?? $0.0.creationDate! < $0.1.modificationDate ?? $0.0.creationDate!) == ascending
            })
            
        case .size:
            return sorted({
                ($0.0.fileSize ?? 0 < $0.1.fileSize ?? 0) == ascending
            })
        }
    }
    
    private func sorted(_ by: (Path, Path) -> Bool) -> [Path] {
        return self.children().sorted(by: by)
    }
}
