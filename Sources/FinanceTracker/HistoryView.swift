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
                    Text(formatNumber(database.historyAnalytics?.expense))
                }
                HStack {
                    Text("Income:")
                    Spacer()
                    Text(formatNumber(database.historyAnalytics?.credit))
                }
                HStack {
                    Text("Closing balance:")
                    Spacer()
                    Text(formatNumber(database.historyAnalytics?.amount))
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
                await Task.yield()
                try? database.refreshMonthlyTransaction()
            }
        }
    }
    
    private func formatNumber(_ number: Double?) -> String {
        guard let number else {
            return "0"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.groupingStyle = .defaultGrouping
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

#Preview {
    HistoryView()
}
