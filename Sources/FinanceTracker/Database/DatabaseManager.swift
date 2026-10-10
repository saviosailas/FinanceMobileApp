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
    
    let dbpath = URL.applicationSupportDirectory.appendingPathComponent("finance.db")
    
    private init() {
        print("[~][db] init ")
        
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
    
    func safeInit() async { }
    
    func createTransaction(amount: Double, type: String, account: String) async {
        guard let ctx = dbContext else {
            print("[~][db] Database context is not initialized")
            return
        }
        
        do {
            // Create a transaction instance with the provided values
            let transaction = Transaction(
                amount: amount,
                transationType: type,
                account: account
            )
            
            // Insert the transaction into the database
            _ = try ctx.insert(transaction)
            
            print("[~][db] Transaction created successfully: \(transaction)")
        } catch {
            print("[~][db] Error creating transaction: \(error)")
        }
    }
    
}
