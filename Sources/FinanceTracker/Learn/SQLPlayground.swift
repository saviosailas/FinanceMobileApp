//
//  SQLPlayground.swift
//  FinanceMobileApp
//
//  Created by user on 03/10/26.
//


import SwiftUI

struct SQLPlayground: View {
    /// The shared SQL context for the view hierarchy
    @State var database: SQLDatabase = getDatabase()

    var body: some View {
        NavigationStack {
            SQLItemListView()
                .environment(database)
        }
    }
    
    static func getDatabase() -> SQLDatabase {
        do {
            return try SQLDatabase(name: "database.sqlite")
        } catch {
            // do not crash the app
            print("SQLDatabase without context e: \(error)")
            return SQLDatabase()
        }
    }
}

/// A list of `SQLItem` instances with create/read/update/delete capabilities
struct SQLItemListView: View {
    @Environment(SQLDatabase.self) var database

    var body: some View {
        
        VStack {
            Button {
                withAnimation {
//                    database.createItem()
                    database.createTransaction(amount: 100.0, date: .now, type: "Debit", accountName: "BANK Test bank")
                }
            } label: {
                Label("Add", systemImage: "plus")
            }
            
            
            List {
                Section {
//                    ForEach(database.items) { item in
                    ForEach(database.transactionItem) { item in
                        NavigationLink(value: item) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(item.amount.description)
                                        .foregroundStyle(item.type == "DEBIT" ? Color.green : Color.red)
                                    Text(item.accountName)
                                }
//                                if item.name.isEmpty {
//                                    Text("New Item")
//                                        .foregroundStyle(.secondary)
//                                } else {
//                                    Text(item.name)
//                                }
                                Text(item.date.formatted())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { indices in
                        database.deleteItems(atOffsets: Array(indices))
                    }
//                    .onMove { from, to in
//                        database.moveItems(fromOffsets: Array(from), toOffset: to)
//                    }
                } footer: {
                    NavigationLink {
                        TextEditor(text: .constant(database.statements.joined(separator: "\n")))
                            .font(Font.body.monospaced())
                            .navigationTitle("SQL Log")
                    } label: {
                        Text(database.lastActionSQL ?? "SQL Log")
                            .font(Font.caption.monospaced())
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                    }
                }
            }
            .navigationDestination(for: SQLItem.self) { item in
                SQLItemEditorView(item: item)
                    .environment(database)
            }
        }
    }
}

/// An editor for a `SQLItem`
struct SQLItemEditorView: View {
    @State var item: SQLItem
    @Environment(SQLDatabase.self) var database
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            
            Button("Save") {
                database.updateItem(item)
                dismiss() // pop back up on save
            }
            
            TextField("Name", text: $item.name)
            DatePicker("Date", selection: $item.date)
        }
    }
}

