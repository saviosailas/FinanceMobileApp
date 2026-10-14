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
            
            try ctx.createTableIfNotExists(TransactionItem.self)
            
            print("[~][db] complete init")
            
        } catch {
            print("[~][db] Database setup error: \(error)")
        }
    }
    
    func safeInit() async { }
    
    func createTransaction(amount: Double, type: String, account: String, note: String = "") async {
        guard let ctx = dbContext else {
            print("[~][db] Database context is not initialized")
            return
        }
        
        do {
            let transaction = TransactionItem(
                amount: amount,
                date: Date(),
                type: type,
                accountName: account,
                userNote: note
            )
            
            _ = try ctx.insert(transaction)
            
            print("[~][db] Transaction created successfully: \(transaction)")
        } catch {
            print("[~][db] Error creating transaction: \(error)")
        }
    }
    
    func fetchTotalBalance() async -> Double {
        guard let ctx = dbContext else { return 0.0 }
        do {
            let rows = try ctx.query(TransactionItem.self).eval().load()
            var total = 0.0
            for item in rows {
                if item.type.lowercased() == "income" {
                    total += item.amount
                } else {
                    total -= item.amount
                }
            }
            return total
        } catch {
            print("[~][db] Error fetching total balance: \(error)")
            return 0.0
        }
    }
    
    func fetchMonthlySpend() async -> Double {
        guard let ctx = dbContext else { return 0.0 }
        do {
            let rows = try ctx.query(TransactionItem.self).eval().load()
            let calendar = Calendar.current
            let now = Date()
            let currentMonth = calendar.component(.month, from: now)
            let currentYear = calendar.component(.year, from: now)
            
            var total = 0.0
            for item in rows {
                let itemDate = item.date
                let itemMonth = calendar.component(.month, from: itemDate)
                let itemYear = calendar.component(.year, from: itemDate)
                if item.type.lowercased() == "expense" && itemMonth == currentMonth && itemYear == currentYear {
                    total += item.amount
                }
            }
            return total
        } catch {
            print("[~][db] Error fetching monthly spend: \(error)")
            return 0.0
        }
    }
    
    func fetchMonthlyIncome() async -> Double {
        guard let ctx = dbContext else { return 0.0 }
        do {
            let rows = try ctx.query(TransactionItem.self).eval().load()
            let calendar = Calendar.current
            let now = Date()
            let currentMonth = calendar.component(.month, from: now)
            let currentYear = calendar.component(.year, from: now)
            
            var total = 0.0
            for item in rows {
                let itemDate = item.date
                let itemMonth = calendar.component(.month, from: itemDate)
                let itemYear = calendar.component(.year, from: itemDate)
                if item.type.lowercased() == "income" && itemMonth == currentMonth && itemYear == currentYear {
                    total += item.amount
                }
            }
            return total
        } catch {
            print("[~][db] Error fetching monthly income: \(error)")
            return 0.0
        }
    }
    
}
