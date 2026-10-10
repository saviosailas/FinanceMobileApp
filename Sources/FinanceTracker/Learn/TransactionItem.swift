//
//  File.swift
//  FinanceMobileApp
//
//  Created by user on 11/10/26.
//

import SwiftUI
import SkipSQL


/// A type that can read and write its values to the `SQL_ITEM` table.
public struct TransactionItem: Identifiable, Hashable, SQLCodable {
    public var id: Int64
    static let id = SQLColumn(name: "ID", type: .long, primaryKey: true, autoincrement: true)

    public var amount: Double
    static let amount = SQLColumn(name: "AMOUNT", type: .real, index: SQLIndex(name: "IDX_AMOUNT"))

    public var date: Date
    static let date = SQLColumn(name: "DATE", type: .real)

    public var type: String
    static let type = SQLColumn(name: "TYPE", type: .text)
    
    public var accountName: String
    static let accountName = SQLColumn(name: "ACCOUNT_NAME", type: .text, index: SQLIndex(name: "IDX_ACC_NAME"))

    public static let table = SQLTable(name: "TRANSACTION_ITEM", columns: [id, amount, date, type, accountName])

    public init(
        id: Int64 = 0,
        amount: Double,
        date: Date,
        type: String,
        accountName: String
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
        self.accountName = accountName
    }

    /// Required initializer to create an instance from the given `SQLRow = [SQLColumn: SQLValue]`
    public init(row: SQLRow, context: SQLContext) throws {
        self.id = try Self.id.longValueRequired(in: row)
        self.amount = try Self.amount.realValueRequired(in: row)
        self.date = try Self.date.dateValueRequired(in: row)
        self.type = try Self.type.textValueRequired(in: row)
        self.accountName = try Self.accountName.textValueRequired(in: row)
    }

    /// Encode the current instance into the given `SQLRow` dictionary.
    public func encode(row: inout SQLRow) throws {
        row[Self.id] = SQLValue(self.id)
        row[Self.amount] = SQLValue(self.amount)
        row[Self.date] = SQLValue(self.date.timeIntervalSince1970)
        row[Self.type] = SQLValue(self.type)
        row[Self.accountName] = SQLValue(self.accountName)
    }
}
