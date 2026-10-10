//
//  SQLItem.swift
//  FinanceMobileApp
//
//  Created by user on 10/10/26.
//

import SwiftUI
import SkipSQL


/// A type that can read and write its values to the `SQL_ITEM` table.
public struct SQLItem: Identifiable, Hashable, SQLCodable {
    public var id: Int64
    static let id = SQLColumn(name: "ID", type: .long, primaryKey: true, autoincrement: true)

    public var name: String
    static let name = SQLColumn(name: "NAME", type: .text, index: SQLIndex(name: "IDX_NAME"))

    public var date: Date
    static let date = SQLColumn(name: "DATE", type: .real)

    public var sortOrder: Double?
    static let sortOrder = SQLColumn(name: "SORT_ORDER", type: .real, index: SQLIndex(name: "IDX_SORT"))

    public static let table = SQLTable(name: "SQL_ITEM", columns: [id, name, date, sortOrder])

    public init(id: Int64 = 0, name: String, date: Date, sortOrder: Double? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.sortOrder = sortOrder
    }

    /// Required initializer to create an instance from the given `SQLRow = [SQLColumn: SQLValue]`
    public init(row: SQLRow, context: SQLContext) throws {
        self.id = try Self.id.longValueRequired(in: row)
        self.name = try Self.name.textValueRequired(in: row)
        self.date = try Self.date.dateValueRequired(in: row)
        self.sortOrder = Self.sortOrder.realValue(in: row)
    }

    /// Encode the current instance into the given `SQLRow` dictionary.
    public func encode(row: inout SQLRow) throws {
        row[Self.id] = SQLValue(self.id)
        row[Self.name] = SQLValue(self.name)
        row[Self.date] = SQLValue(self.date.timeIntervalSince1970)
        row[Self.sortOrder] = SQLValue(self.sortOrder)
    }
}
