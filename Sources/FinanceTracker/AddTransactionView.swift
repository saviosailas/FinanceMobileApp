//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by savio sailas on 17/08/26.
//

import SwiftUI

struct AddTransactionView: View {
    
    @StateObject var vm: AddTransactionViewModel = AddTransactionViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            TextField("Amount", text: $vm.amount)
                .padding()
            TextField("Category", text: $vm.name)
                .padding()
            
            Button(action: {
                vm.addEvent()
            }) {
                Text(verbatim: "Credit")
            }
            .padding()
            
            Button(action: {
                vm.addEvent()
            }) {
                Text(verbatim: "Debit")
            }
        }
    }
}

#Preview {
    AddTransactionView()
}
