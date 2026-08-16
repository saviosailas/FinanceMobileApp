//
//  TransactionItemViewModel.swift
//  FinanceMobileApp
//
//  Created by Savio Sailas on 15/08/26.
//

import SwiftUI

final class TransactionItemViewModel: Hashable {
    
    static func == (lhs: TransactionItemViewModel, rhs: TransactionItemViewModel) -> Bool {
        lhs.name == rhs.name
        && lhs.date == rhs.date
        && lhs.time == rhs.time
        && lhs.amount == rhs.amount
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(name)
           hasher.combine(date)
           hasher.combine(time)
           hasher.combine(amount)
       }
    
    var type: TransactionType = .debit
    var name: String = ""
    var date: String = ""
    var time: String = ""
    var amount: Double = 0.0
    
    var displayAmount: String {
        "\(amount)"
    }
    
    var transactionIcon: String {
        switch type {
        case .credit:
            return "+"
        case .debit:
            return "-"
        case .transfer:
            return "<>"
        }
    }
    
    var iconColor: Color {
        switch type {
        case .credit:
            return Color.green
        case .debit:
            return Color.red
        case .transfer:
            return Color.blue
        }
    }
    
    init(type: TransactionType, name: String, date: String, time: String, amount: Double) {
        self.type = type
        self.name = name
        self.date = date
        self.time = time
        self.amount = amount
    }
}
