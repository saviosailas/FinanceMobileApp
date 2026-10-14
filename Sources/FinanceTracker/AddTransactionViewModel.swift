//
//  AddTransactionViewModel.swift
//  FinanceMobileApp
//
//  Created by user on 03/10/26.
//

import Foundation
import Observation

enum TransferType: String, CaseIterable {
    case debit
    case credit
    case transfer
}

enum AccountType: String, CaseIterable {
    case bankSavings = "Bank savings"
    case bankFD = "Bank FD"
    case wallet = "Wallet"
}

/// The Observable ViewModel used by the application.
@Observable public class AddTransactionViewModel {

    
//    let accountTypes: [String] = AccountType.allCases.map { $0.rawValue }
    @ObservationIgnored let accountTypes: [String] = AccountType.allCases.map(\.rawValue)
    
    @ObservationIgnored let transferTypes: [String] = TransferType.allCases.map { $0.rawValue }
    
    var selectedAccount: String = AccountType.bankSavings.rawValue
    
    var selectedTransferType: String = TransferType.credit.rawValue
    
    var amount: String = ""
    
    var note: String = ""


    func addButtonAction() async {
        print("[~][vm] amount: \(amount) | type: \(selectedTransferType) | account: \(selectedAccount)")
        guard let amount: Double  = Double(amount.trimmingCharacters(in: .whitespaces)) else {
            print("[~][vm] invalid amount")
            return
        }
        print("[~][vm] amount: Double(\(amount))")

        await DatabaseManager.shared.createTransaction(amount: amount, type: selectedTransferType, account: selectedAccount)
    }
    
}
