//
//  SQLDatabase.swift
//  FinanceMobileApp
//
//  Created by user on 10/10/26.
//

import Observation
import SkipSQL
import Foundation


/// The database for the view hierarchy, which holds a `SQLContext`
@Observable public class SQLDatabase {
    /// The internal SQLContext that manages the database
    private let context: SQLContext?
    /// The current list of items
    public var items: [SQLItem] = []
    
    // MARK: Education
    
    public var transactionItem: [TransactionItem] = []
    
    public var balance: Double = 0.0
    
    public var thisMonthExpense: Double = 0.0
    
    public var thisMonthCredit: Double = 0.0
    
    
    /// The list of all the statements that have been executed
    public var statements: [String] = []
    /// The most recent error mssage
    public var errorMessage: String? = nil
    
    /// A summary of the last statement that did something interesting like insert or delete
    public var lastActionSQL: String? {
        statements.last(where: { sql in
            !sql.hasPrefix("PRAGMA ") && !sql.hasPrefix("SELECT ")
        })
    }
    
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
            self.statements.append(sql)
        }
        
        try createOrMigrateSchema()
        try readItems()
    }
    
    public init() {
        context = nil
        items = []
        statements = []
        errorMessage = nil
        
    }
    
    private func createOrMigrateSchema() throws {
        
        guard let context else { return }
        
        print("[~] context.userVersion: \(context.userVersion)")
        // schema creation and migration is tracked in the database's userVersion
        if context.userVersion < 1 {
            for ddl in SQLItem.table.createTableSQL(columns: [SQLItem.id, SQLItem.name, SQLItem.date]) {
                print("[~] ddl: \(ddl)")
                try context.exec(ddl)
                print("[~] ddl complete")
            }
            
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
            //            for ddl in SQLItem.table.addColumnSQL(column: SQLItem.sortOrder) {
            //                try context.exec(ddl)
            //            }
            
            for ddl in TransactionItem.table.addColumnSQL(column: TransactionItem.note) {
                try context.exec(ddl)
            }
            context.userVersion = 2
            
            // MARK: Eduction
            //            let transactionColumn = [
            //                TransactionItem.id,
            //                TransactionItem.amount,
            //                TransactionItem.date,
            //                TransactionItem.type,
            //                TransactionItem.accountName
            //            ]
            //
            //            for ddl in TransactionItem.table.createTableSQL(columns: transactionColumn) {
            //                try context.exec(ddl)
            //            }
            //
            //            context.userVersion = 2
        }
        
        if context.userVersion < 3 {
            // future schema migrations go here…
            for ddl in AnalyticsItem.table.createTableSQL(ifNotExists: true, columns: [AnalyticsItem.id, AnalyticsItem.amount, AnalyticsItem.expense, AnalyticsItem.credit]) {
                try context.exec(ddl)
            }
            context.userVersion = 3
            // MARK: Eduction
            //            let transactionColumn = [
            //                TransactionItem.id,
            //                TransactionItem.amount,
            //                TransactionItem.date,
            //                TransactionItem.type,
            //                TransactionItem.accountName
            //            ]
            //
            //            for ddl in TransactionItem.table.createTableSQL(columns: transactionColumn) {
            //                try context.exec(ddl)
            //            }
            
            //            context.userVersion = 3
        }
    }
    
    /// Perform the given operation and reload all the rows afterwards
    @discardableResult private func reloading<T>(_ f: () throws -> T) -> Swift.Result<T, Error> {
        defer { try? readItems() }
        do {
            return try .success(f())
        } catch {
            logger.error("error performing operation: \(error)")
            self.errorMessage = error.localizedDescription
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
        //        self.items = try context.query(SQLItem.self)
        //            .orderBy(SQLItem.sortOrder, order: .descending)
        //            .eval().load()
    }
    
    /// Add a new item to the database
    public func createItem(name: String = "") {
        guard let context else { return }
        reloading {
            let maxSort = items.compactMap(\.sortOrder).max() ?? 0.0
            let item = SQLItem(name: name, date: Date(), sortOrder: maxSort + 100.0)
            try context.insert(item)
        }
    }
    
    
    // MARK: Education
    
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
            
        }
    }
    
    /// Update an existing item in the database
    public func updateItem(_ item: SQLItem) {
        guard let context else { return }
        reloading {
            try context.update(item)
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
            
            let calendar = Calendar.current
            let now = Date()
            guard let interval = calendar.dateInterval(of: .month, for: now) else {
                return
            }
            
//            let predicate = TransactionItem.date
//                .greaterThanOrEqual(SQLValue(interval.start.timeIntervalSince1970))
//                .and(
//                    TransactionItem.date.lessThan(
//                        SQLValue(interval.end.timeIntervalSince1970)
//                    )
//                )
//            
//            let transactions = try context.query(TransactionItem.self)
//                .where(predicate)
//                .orderBy(TransactionItem.date, order: .descending)
//                .eval()
//                .load()
//            
//            print("[~] monlty transactions: \(transactions.count)")
            
            let predicate2 = TransactionItem.date
                .greaterThanOrEqual(SQLValue(interval.start.timeIntervalSince1970))
                .and(TransactionItem.date.lessThan(
                        SQLValue(interval.end.timeIntervalSince1970)
                    )
                )
                .and(TransactionItem.type.equals(
                        SQLValue(TransactionType.debit.rawValue)
                    )
                )
            
            let debits = try context.query(TransactionItem.self)
                .where(predicate2)
                .orderBy(TransactionItem.date, order: .descending)
                .eval()
                .load()
            let debit = debits.map( { $0.amount}).reduce(0.0, +)

            
            print("[~] debit: \(debits.count)")
            print("[~] debit: \(debit )")

            
            
            let predicate3 = TransactionItem.date
                .greaterThanOrEqual(SQLValue(interval.start.timeIntervalSince1970))
                .and(TransactionItem.date.lessThan(
                        SQLValue(interval.end.timeIntervalSince1970)
                    )
                )
                .and(TransactionItem.type.equals(
                        SQLValue(TransactionType.credit.rawValue)
                    )
                )
            
            let credits = try context.query(TransactionItem.self)
                .where(predicate3)
                .orderBy(TransactionItem.date, order: .descending)
                .eval()
                .load()
            let credit = credits.map( { $0.amount}).reduce(0.0, +)
            
            
            print("[~] credit: \(credits.count)")
            print("[~] credit: \(credit)")
            
            
            // filter quest based on debit and credit
            
            // sim credit and debit respectively
            
            thisMonthCredit = credit
            thisMonthExpense = debit
            
            let data = try context.query(AnalyticsItem.self)
                .eval()
                .load(count: 1)
            print("data: \(data)")
            
            let pred = [
                TransactionItem.type.equals(
                    SQLValue(TransactionType.credit.rawValue)
                ),
                TransactionItem.type.equals(
                    SQLValue(TransactionType.debit.rawValue)
                )
            ]
            
            var total = 0.0
            for predicate in pred {
                let result = try context.query(TransactionItem.self)
                    .where(predicate)
//                    .orderBy(TransactionItem.date, order: .descending)
                    .eval()
                    .load()
                let amount = result.map( { $0.amount }) .reduce(0.0, +)
                if total == 0.0 { // first [ credit, debit ]
                    total += amount
                } else {
                    total -= amount
                }
            }
            balance = total
            
        }
    }
    
    
    
    
    /// Move the items from the given `source` offsets in the `items` array to the given `destination` index
    //    public func moveItems(fromOffsets source: Array<Int>, toOffset destination: Int) {
    //        guard let context else { return }
    //        reloading {
    //            for index in source {
    ////                var item = items[index]
    //                var item = transactionItem[index]
    //                // update the "sortOrder" column to be halfway between the two adjacent items, or max+100.0 for moving to the first row
    //                let orderOffset = 100.0
    //                let nextOrder = destination == items.count ? 0.0 : items[destination].sortOrder ?? 0.0
    //                let prevOrder = destination == 0 ? 0.0 : items[destination - 1].sortOrder ?? 0.0
    //
    //                item.sortOrder = destination == 0 ? (nextOrder + orderOffset)
    //                    : destination == items.count ? (prevOrder - orderOffset)
    //                    : (nextOrder + ((prevOrder - nextOrder) / 2.0))
    //                try context.update(item)
    //            }
    //        }
    //    }
}
