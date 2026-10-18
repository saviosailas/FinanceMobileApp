////
////  AddTransactionViewModel.swift
////  FinanceMobileApp
////
////  Created by user on 03/10/26.
////
//
import Foundation
import Observation
//
enum TransactionType: String, CaseIterable {
    case debit
    case credit
//    case transfer
}

enum AccountType: String, CaseIterable {
    case bankSavings = "Bank savings"
    case bankFD = "Bank FD"
    case wallet = "Wallet"
}

/// The Observable ViewModel used by the application.
@Observable public class AddTransactionViewModel {

    
    @ObservationIgnored let accountTypes: [String] = AccountType.allCases.map(\.rawValue)
    
    @ObservationIgnored let transferTypes: [String] = TransactionType.allCases.map { $0.rawValue }
    
    var selectedAccount: String = AccountType.bankSavings.rawValue
    
    var selectedTransferType: String = TransactionType.credit.rawValue
    
    var amount: String = ""
    
    var note: String = ""
    
    var date: Date = Date.now
    
}
