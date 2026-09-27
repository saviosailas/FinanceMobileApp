//
//  File.swift
//  FinanceMobileApp
//
//  Created by user on 26/09/26.
//

import Foundation
import SkipSQL
import SkipSQLCore

actor DatabaseManager {
    static let shared = DatabaseManager()
    
    private var dbContext: SQLContext?
    
    let dbpath = URL.applicationSupportDirectory.appendingPathComponent("db.sqlite")
    
    private init() {
        print("[~][db] init ")
        let dbpath = URL.applicationSupportDirectory
            .appendingPathComponent("finance.db")
        
        do {
            let fm = FileManager.default
            let directory = dbpath.deletingLastPathComponent()
            if !fm.fileExists(atPath: directory.path) {
                try fm.createDirectory(at: directory, withIntermediateDirectories: true)
            }
            
            let ctx = try SQLContext(path: dbpath.path, flags: [.create, .readWrite], configuration: .platform)
            self.dbContext = ctx
            
            try ctx.createTableIfNotExists(Transaction.self)
            
            print("[~][db] complete init")
            
        } catch {
            print("[~][db] Database setup error: \(error)")
        }
    }
    
    private func setupDatabase() {
        
    }
    
    func createTables() throws {
        
    }
    
}
