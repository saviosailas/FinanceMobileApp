//
//  File.swift
//  FinanceMobileApp
//
//  Created by user on 14/10/26.
//

import SwiftUI
import SkipSQL


/// A type that can read and write its values to the `SQL_ITEM` table.
public struct AnalyticsItem: Identifiable, Hashable, SQLCodable {
    public var id: Int64
    static let id = SQLColumn(name: "ID", type: .long, primaryKey: true, autoincrement: true)

    public var amount: Double
    static let amount = SQLColumn(name: "AMOUNT", type: .real, index: SQLIndex(name: "IDX_AMOUNT"))
    
    public var expense: Double
    static let expense = SQLColumn(name: "EXPENSE", type: .real, index: SQLIndex(name: "IDX_AMOUNT"))
    
    public var credit: Double
    static let credit = SQLColumn(name: "CREDIT", type: .real, index: SQLIndex(name: "IDX_AMOUNT"))


    public static let table = SQLTable(name: "ANALYTICS_ITEM", columns: [id, amount, expense, credit])

    public init(
        id: Int64 = 0,
        amount: Double,
        expense: Double,
        credit: Double
    ) {
        self.id = id
        self.amount = amount
        self.expense = expense
        self.credit = credit
    }

    /// Required initializer to create an instance from the given `SQLRow = [SQLColumn: SQLValue]`
    public init(row: SQLRow, context: SQLContext) throws {
        self.id = try Self.id.longValueRequired(in: row)
        self.amount = try Self.amount.realValueRequired(in: row)
        self.expense = try Self.expense.realValueRequired(in: row)
        self.credit = try Self.credit.realValueRequired(in: row)
    }

    /// Encode the current instance into the given `SQLRow` dictionary.
    public func encode(row: inout SQLRow) throws {
        row[Self.id] = SQLValue(self.id)
        row[Self.amount] = SQLValue(self.amount)
        row[Self.expense] = SQLValue(self.expense)
        row[Self.credit] = SQLValue(self.credit)
    }
}

