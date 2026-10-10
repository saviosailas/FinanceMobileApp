//
//  AddTransactionViewModel.swift
//  FinanceMobileApp
//
//  Created by user on 03/10/26.
//

import Foundation
import Observation

enum TransferType: String {
    case debit
    case credit
}

/// The Observable ViewModel used by the application.
@Observable public class AddTransactionViewModel {

    
    let accountTypes = ["HDFC savings", "HDFC FD", "Wallet"]
    
    let transferTypes = [TransferType.credit.rawValue, TransferType.debit.rawValue] //, "Transfer"]
    
    var selectedAccount = "HDFC savings"
    
    var selectedTransferType = TransferType.credit.rawValue
    
    var amount: String = ""


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
