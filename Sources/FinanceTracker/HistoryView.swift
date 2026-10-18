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
                        note: item.note
                    )
                    .padding(.bottom, 5.0)
                }
            }
            Divider()
            DisclosureGroup("Overview", isExpanded: $expanded) {
                HStack {
                    Text("Expense:")
                    Spacer()
                    Text("52,021")
                }
                HStack {
                    Text("Income:")
                    Spacer()
                    Text("52,021")
                }
                HStack {
                    Text("Closing balance:")
                    Spacer()
                    Text("52,021")
                }
            }
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
