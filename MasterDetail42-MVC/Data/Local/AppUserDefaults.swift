//
//  AppUserDefaults.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/07.
//

import Foundation

// MARK: - AppUserDefaults

class AppUserDefaults {
    
    // MARK: - Variables And Properties
    
    static let shared = AppUserDefaults()
    
    // UserDefaults keys
    private let kDefaults = UserDefaults.standard
    private let kIsListLayout = "IsListLayout"
    private let kLastVisit = "LastVisit"
    
    private var isListLayout: Bool!
    private var lastVisit: String!
    
    // MARK: - Class methods
    
    private init() {
        loadAll()
    }
    
    private func loadAll() {
        isListLayout = kDefaults.bool(forKey: kIsListLayout)
        lastVisit = kDefaults.string(forKey: kLastVisit)
    }
    
    func saveAll() {
        kDefaults.set(isListLayout, forKey: kIsListLayout)
        kDefaults.set(lastVisit, forKey: kLastVisit)
    }
    
    func resetAll() {
        kDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        kDefaults.synchronize()
        loadAll()
    }
    
    func setIsListLayout(_ isListLayout: Bool) {
        self.isListLayout = isListLayout
        kDefaults.set(self.isListLayout, forKey: kIsListLayout)
    }
    
    func getIsListLayout() -> Bool {
        return isListLayout
    }
    
    func setLastVisit(_ lastVisit: String) {
        self.lastVisit = lastVisit
        kDefaults.set(self.lastVisit, forKey: kLastVisit)
    }
    
    func getLastVisit() -> String {
        let ret = lastVisit ?? getCurrentDateTime()
        setLastVisit(getCurrentDateTime())
        return ret
    }
    
    private func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
}
