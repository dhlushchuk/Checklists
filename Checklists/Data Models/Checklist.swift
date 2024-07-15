//
//  Checklist.swift
//  Checklists
//
//  Created by Dzmitry Hlushchuk on 21.06.24.
//

import UIKit

class Checklist: NSObject, Codable {
    
    var name: String
    var items: [ChecklistItem] = []
    var iconName = "deskclock"
    
    init(name: String, iconName: String = "deskclock") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        items.reduce(0) { $0 + ($1.checked ? 0 : 1) }
    }
    
    func sortListItems() {
        items.sort { $0.dueDate > $1.dueDate }
    }
    
}
