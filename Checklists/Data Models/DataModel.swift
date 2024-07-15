//
//  DataModel.swift
//  Checklists
//
//  Created by Dzmitry Hlushchuk on 21.06.24.
//

import Foundation

class DataModel {
    
    enum UserDefaultKeys: String {
        case checklistIndex = "ChecklistIndex"
        case isFirstTime = "FirstTime"
        case checklistItemID = "ChecklistItemID"
    }
    
    let userDefaults = UserDefaults.standard
    
    var lists: [Checklist] = []
    
    var indexOfSelectedChecklist: Int {
        get {
            userDefaults.integer(forKey: UserDefaultKeys.checklistIndex.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.checklistIndex.rawValue)
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath())
            lists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch {
            print("Error decoding list array: \(error.localizedDescription)")
        }
    }
    
    func registerDefaults() {
        let dictionary = [
            UserDefaultKeys.checklistIndex.rawValue: -1,
            UserDefaultKeys.isFirstTime.rawValue: true
        ] as [String: Any]
        userDefaults.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let isFirstTime = userDefaults.bool(forKey: UserDefaultKeys.isFirstTime.rawValue)
        if isFirstTime {
            lists.append(Checklist(name: "List"))
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: UserDefaultKeys.isFirstTime.rawValue)
        }
    }
    
    func sortChecklists() {
        lists.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
    
    static func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: UserDefaultKeys.checklistItemID.rawValue)
        userDefaults.set(itemID + 1, forKey: UserDefaultKeys.checklistItemID.rawValue)
        return itemID
    }
    
}
