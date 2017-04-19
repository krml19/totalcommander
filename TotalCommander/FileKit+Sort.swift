//
//  FileKit+Sort.swift
//  TotalCommander
//
//  Created by Marcin Karmelita on 19/04/17.
//  Copyright © 2017 Marcin Karmelita. All rights reserved.
//

import Foundation
import FileKit

extension Path {
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
    
    func sorted(by sortDescriptor: NSSortDescriptor?) -> [Path] {
        guard let sortDescriptor = sortDescriptor else { return children() }
        return sorted(by: sortDescriptor.key, ascending: sortDescriptor.ascending)
    }
    
    func sorted(by type: String?, ascending: Bool = true) -> [Path] {
        guard type != nil, let type = SortingOptions(rawValue: type!) else {
            return self.children()
        }
        switch type {
        case .name:
            return sorted({
                ($0.0.fileName < $0.1.fileName) == ascending
            })
        case .modificationDate:
            return sorted({
                ($0.0.modificationDate ?? $0.0.creationDate! < $0.1.modificationDate ?? $0.0.creationDate!) == ascending
            })
            
        case .size:
            return sorted({
                ($0.0.fileSize ?? 0 < $0.1.fileSize ?? 0) == ascending
            })
            
        default:
            return self.children()
        }
    }
    
    private func sorted(_ by: (Path, Path) -> Bool) -> [Path] {
        return self.children().sorted(by: by)
    }
}