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

    
    let accountTypes = ["HDFC current", "HDFC FD", "Wallet"]
    
    let transferTypes = ["Credit", "Debit"] //, "Transfer"]
    
    var selectedAccount = "HDFC current"
    
    var selectedTransferType = "Debit"
    
    var amount: String = ""
    
    
    func addButtonAction() {
        
    }
    
}
