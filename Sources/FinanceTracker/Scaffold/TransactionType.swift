//
//  TransactionType.swift
//  FinanceMobileApp
//
//  Created by Savio Sailas on 15/08/26.
//


enum TransactionType {
    /// Received money from outside
    case credit
    case debit
    
    /// Transfer money between multiple accounts,
    /// transaction via ATM and etc
    case transfer
}
