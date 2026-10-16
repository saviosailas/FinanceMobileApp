//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 02/08/26.
//

import SwiftUI

struct HomeMainCardView: View {
    
    @State var isExpanded: Bool = false
    
    @Environment(SQLDatabase.self) var database: SQLDatabase
    
    var body: some View {
        HStack(alignment: .center, content: {
            
            VStack(alignment: .leading, spacing: 0.0, content: {
                Text(formatNumber(database.balance))
                    .font(.title)
                    .foregroundStyle(Color("textPrimary", bundle: .module))
                    .onTapGesture {
                        print("tapped me")
                        database.refreshCurrentMonthAnalytics()
                    }
                Text("Balance")
                    .font(.caption)
                    .foregroundStyle(Color("textSecondary", bundle: .module))
                
                // Expense / income info
                
                DisclosureGroup(isExpanded: $isExpanded, content: {
                    VStack(alignment: .leading, spacing: 5.0, content: {

                        HStack(alignment: .center, content: {
                            Text("Spend this month")
                                .font(.callout)
                                .foregroundStyle(Color("textSecondary", bundle: .module))
                            Spacer()
                            Text(formatNumber(database.thisMonthExpense))
                        })
                        
                        HStack(alignment:.center, content: {
                            Text("Income this month")
                                .font(.callout)
                                .foregroundStyle(Color("textSecondary", bundle: .module))
                            Spacer()
                            Text(formatNumber(database.thisMonthCredit))
                        })
                    })
                }, label: {
                    EmptyView()
                })
                .disabled(true)
                .labelsHidden()

            })
            
            Spacer()
            
        })
        .padding(10)
        .background(content: {
            Color("primaryBG", bundle: .module)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
        })
        
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .inset(by: -2)
                .stroke(Color.orange, lineWidth: 1)
            ,
            alignment: .center)
        		
        .allowsHitTesting(true)
        .onTapGesture {
            isExpanded.toggle()
        }
        .padding()
        .task {
            database.refreshCurrentMonthAnalytics()
        }
    }
    
//    private func refreshData() async {
//        balance = await DatabaseManager.shared.fetchTotalBalance()
//        monthlySpend = await DatabaseManager.shared.fetchMonthlySpend()
//        monthlyIncome = await DatabaseManager.shared.fetchMonthlyIncome()
//    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.groupingStyle = .defaultGrouping
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

#Preview {
    HomeMainCardView()
}
