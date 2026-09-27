//
//  Transaction.swift
//  FinanceMobileApp
//
//  Created by user on 27/09/26.
//

import Foundation
import SkipSQLCore


public struct Transaction: SQLCodable, Equatable {
    
    public static let table: SkipSQLCore.SQLTable = SQLTable(
        name: "TRANSACTIONS",
        columns: [id, amount, date, transactionType, account]
    )
    
    public var id: Int64
    static let id = SQLColumn(name: "ID", type: .long, primaryKey: true, autoincrement: true, unique: true, nullable: false)
    
    public var amount: Double
    static let amount = SQLColumn(name: "AMOUNT", type: .real, nullable: false)
    
    public var date: String
    static let date = SQLColumn(name: "DATE", type: .text, nullable: false, defaultValue: .text(DateFormatter.time.string(from: Date())))
    
    public var transactionType: String
    static let transactionType = SQLColumn(name: "TYPE", type: .text, nullable: false)
    
    public var account: String
    static let account = SQLColumn(name: "ACCOUNT", type: .text, nullable: false)
    
    
    public init(
        id: Int64 = 0,
        amount: Double,
        transationType: String,
        account: String
    ) {
        print("[~][tr] init Transation")
        self.id = id
        self.amount = amount
        self.date = DateFormatter.time.string(from: Date())
        self.transactionType = transationType
        self.account = account
    }
    
    
    /// Required initializer to create an instance from the given `SQLRow = [SQLColumn: SQLValue]`
    public init(row: SQLRow, context: SQLContext) throws {
        print("[~][tr] init context Transaction")
        self.id = try Self.id.longValueRequired(in: row)
        self.amount = Self.amount.realValue(in: row) ?? 0.0
        self.date = try Self.date.textValueRequired(in: row)
        self.transactionType = try Self.transactionType.textValueRequired(in: row)
        self.account = try Self.account.textValueRequired(in: row)
    }
    
    /// Encode the current instance into the given `SQLRow` dictionary.
    public func encode(row: inout SQLRow) throws {
        print("[~][tr] encode Transaction")
        row[Self.id] = SQLValue(self.id)
        row[Self.amount] = SQLValue(self.amount)
        row[Self.date] = SQLValue(self.date)
        row[Self.transactionType] = SQLValue(self.transactionType)
        row[Self.account] = SQLValue(self.account)
    }
    
}


extension DateFormatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


enum TransactionType: String {
    case credit
    case debit
}
