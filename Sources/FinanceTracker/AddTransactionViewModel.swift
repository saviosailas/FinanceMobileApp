//
//  AddTransactionViewModel.swift
//  FinanceMobileApp
//
//  Created by user on 03/10/26.
//

import Foundation
import Observation


/// The Observable ViewModel used by the application.
@Observable public class AddTransactionViewModel {

    
    let accountTypes = ["HDFC savings", "HDFC FD", "Wallet"]
    
    let transferTypes = ["Credit", "Debit"] //, "Transfer"]
    
    var selectedAccount = "HDFC savings"
    
    var selectedTransferType = "Debit"
    
    var amount: String = ""
    
    
    nonisolated(nonsending) func addButtonAction() async {
        print("amount: \(amount) | type: \(selectedTransferType) | account: \(selectedAccount)")
        guard let amount: Double  = Double(amount.trimmingCharacters(in: .whitespaces)) else {
            print("invalid")
            return
        }
        print("amount: Double(\(amount))")
        
        await DatabaseManager.shared.createTransaction(amount: amount, type: selectedTransferType, account: selectedAccount)
    }
    
}
