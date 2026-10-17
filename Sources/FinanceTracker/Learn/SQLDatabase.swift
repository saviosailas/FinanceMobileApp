//
//  SQLDatabase.swift
//  FinanceMobileApp
//
//  Created by user on 10/10/26.
//

import Observation
import SkipSQL
import Foundation


@Observable public class SQLDatabase {
    
    private let context: SQLContext?
    
    // MARK: Education
    
    public var transactionItem: [TransactionItem] = []
    
    public var balance: Double = 0.0
    
    public var thisMonthExpense: Double = 0.0
    
    public var thisMonthCredit: Double = 0.0
    
    private var calendar: Calendar = Calendar.current
    
    /// Create the database context and initialize/migrate the schems
    public init(name: String) throws {
        let dir = URL.applicationSupportDirectory
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        print("[~] sql path: \(dir)")
        let ctx = try SQLContext(path: dir.appendingPathComponent(name).path, flags: [.create, .readWrite], configuration: .platform)
        self.context = ctx
        
        // track all SQL statements that have been executed
        ctx.trace { sql in
            logger.info("SQLPlayground: \(sql)")
        }
        
        try createOrMigrateSchema()
        try readItems()
    }
    
    public init() {
        context = nil
    }
    
    private func createOrMigrateSchema() throws {
        
        guard let context else { return }
        
        print("[~] context.userVersion: \(context.userVersion)")
        // schema creation and migration is tracked in the database's userVersion
        if context.userVersion < 1 {
            
            // MARK: Eduction
            let transactionColumn = [
                TransactionItem.id,
                TransactionItem.amount,
                TransactionItem.date,
                TransactionItem.type,
                TransactionItem.accountName
            ]
            
            for ddl in TransactionItem.table.createTableSQL(columns: transactionColumn) {
                try context.exec(ddl)
            }
            
            context.userVersion = 1
        }
        
        // version 2 of the schema adds the "SORT_ORDER" column, so we add it here and bump the userVersion
        if context.userVersion < 2 {
            for ddl in TransactionItem.table.addColumnSQL(column: TransactionItem.note) {
                try context.exec(ddl)
            }
            context.userVersion = 2
        }
        
        if context.userVersion < 3 {
            // future schema migrations go here…
            for ddl in AnalyticsItem.table.createTableSQL(ifNotExists: true, columns: [AnalyticsItem.id, AnalyticsItem.amount, AnalyticsItem.expense, AnalyticsItem.credit]) {
                try context.exec(ddl)
            }
            context.userVersion = 3
        }
        
        if context.userVersion < 4 {
            for ddl in AnalyticsItem.table.addColumnSQL(column: AnalyticsItem.monthYearCombo) {
                try context.exec(ddl)
            }
            
            context.userVersion = 4
        }
    }
    
    /// Perform the given operation and reload all the rows afterwards
    @discardableResult private func reloading<T>(_ f: () throws -> T) -> Swift.Result<T, Error> {
        defer { try? readItems() }
        do {
            return try .success(f())
        } catch {
            logger.error("error performing operation: \(error)")
            return .failure(error)
        }
    }
    
    /// Read all the items from the database, storing them in the observable `items` property
    func readItems() throws {
        guard let context else { return }
        self.transactionItem = try context.query(TransactionItem.self)
            .orderBy(TransactionItem.date, order: .descending)
            .eval()
            .load()
    }
    
    
    public func getMonthYearCombo(for date: Date) -> Int64 {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let combo: Int64 = Int64("\(month)\(year)") ?? 0
        return combo
    }
    
    public func createTransaction(
        amount: Double,
        date: Date,
        type: String,
        accountName: String,
        note: String
    ) {
        guard let context else {
            print("[~] context nill - createTransaction()")
            return
        }
        reloading {
            let item = TransactionItem(
                amount: amount,
                date: date,
                type: type,
                accountName: accountName,
                userNote: note
            )
            do {
                try context.insert(item)
            } catch {
                print("[~] failed: \(error)")
            }
            
            // MARK: Read the AnalyticsItem
            // MARK: Update respective value
            // MARK: Update SQLite
            
            do {
                let analyticsItem: [AnalyticsItem] = try context.query(AnalyticsItem.self)
                    .eval()
                    .load()
                
                let combo = getMonthYearCombo(for: date)
                if ( analyticsItem.count < 1 ) {
                    print("[~] Empty analytics")
                    var item = AnalyticsItem(id: 1, amount: 0, expense: 0, credit: 0, monthYearCombo: combo)
                    switch type {
                    case TransactionType.credit.rawValue:
                        item.credit = amount
                        item.amount = amount
                    case TransactionType.debit.rawValue:
                        item.expense = amount
                        item.amount = (-1 * amount)
//                    case TransactionType.transfer.rawValue:
//                        break
                    default:
                        fatalError("unknown type")
                    }
                    try context.insert(item)
                } else {
                    print("[~] Eureka!!")
                    guard var firstRow = analyticsItem.first else {
                        fatalError("AnalyticsItem is not empty and unable get first element")
                    }
                    
                    // check if now is different month
                    if firstRow.monthYearCombo != combo {
                        firstRow.credit = 0
                        firstRow.expense = 0
                        firstRow.monthYearCombo = combo
                    }
                    switch type {
                    case TransactionType.credit.rawValue:
                        firstRow.credit += amount
                        firstRow.amount += amount
                    case TransactionType.debit.rawValue:
                        firstRow.expense += amount
                        firstRow.amount -= amount
//                    case TransactionType.transfer.rawValue:
//                        break
                    default:
                        fatalError("unknown type")
                    }
                    try context.update(firstRow)
                }
            } catch let exp {
                print("[~] exp: \(exp)")
            }
        }
    }
    
    /// Delete the items at the given offsets in the `items` array
    public func deleteItems(atOffsets offsets: Array<Int>) {
        guard let context else { return }
        reloading {
            //            try context.delete(instances: offsets.map({ items[$0] }))
            try context.delete(instances: offsets.map({ transactionItem[$0] }))
        }
    }
    
    public func refreshCurrentMonthAnalytics() {
        guard let context else { return }
        reloading {
            
            let analyticsItem = try context.query(AnalyticsItem.self)
                .limit(1)
                .eval()
                .load()
            
            print("[~] analytics = \(analyticsItem)")
            
            thisMonthCredit = analyticsItem.first?.credit ?? 0.0
            thisMonthExpense = analyticsItem.first?.expense ?? 0.0
            balance = analyticsItem.first?.amount ?? 0.0
            
            return
            
            ///            let predicate = TransactionItem.date
            ///                .greaterThanOrEqual(SQLValue(interval.start.timeIntervalSince1970))
            ///               .and(
            ///                    TransactionItem.date.lessThan(
            ///                        SQLValue(interval.end.timeIntervalSince1970)
            ///                    )
            ///                )
            ///
            ///            let transactions = try context.query(TransactionItem.self)
            ///                .where(predicate)
            ///                .orderBy(TransactionItem.date, order: .descending)
            ///                .eval()
            ///                .load()
            ///
            ///
            ///            let pred = [
            ///                TransactionItem.type.equals(
            ///                    SQLValue(TransactionType.credit.rawValue)
            ///                ),
            ///                TransactionItem.type.equals(
            ///                    SQLValue(TransactionType.debit.rawValue)
            ///                )
            ///            ]
            
        }
    }
}
