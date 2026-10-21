//
//  HistoryView.swift
//  FinanceMobileApp
//
//  Created by user on 17/10/26.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(SQLDatabase.self) private var database: SQLDatabase
    @State var expanded: Bool = false
    
    var body: some View {
        
        @Bindable var database = database
        
        VStack {
            ScrollView {
                ForEach(database.historyTransactions) { item in
                    DebitCellView(
                        amount: item.amount,
                        account: item.accountName,
                        type: item.type,
                        date: item.date,
                        note: item.note,
                        onDelete: {
                            database.deleteTransaction(item)
                            try? database.refreshMonthlyTransaction()
                        }
                    )
                    .padding(.bottom, 5.0)
                }
            }
            Divider()

            DisclosureGroup("more info", isExpanded: $expanded) {
                HStack {
                    Text("Expense:")
                    Spacer()
                    Text("\(database.historyAnalytics?.expense ?? 0.0)")
                }
                HStack {
                    Text("Income:")
                    Spacer()
                    Text("\(database.historyAnalytics?.credit ?? 0.0)")
                }
                HStack {
                    Text("Closing balance:")
                    Spacer()
                    Text("\(database.historyAnalytics?.amount ?? 0.0)")
                }
            }
            .padding(.horizontal)
            DatePicker(selection: $database.selectedDate, displayedComponents: .date) {
                Text("Choose the month and Year")
            }
            .padding()
            .onChange(of: database.selectedDate) { oldValue, newValue in
                Task {
                    print("oldValue: \(oldValue)  -  newValue: \(newValue)")
                    try? database.refreshMonthlyTransaction()
                }
            }
            .task {
                if database.historyTransactions.isEmpty {
                    await Task.yield()
                    try? database.refreshMonthlyTransaction()
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
