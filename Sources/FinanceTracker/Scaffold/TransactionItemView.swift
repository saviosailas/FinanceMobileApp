//
//  DebitListView.swift
//  FinanceMobileApp
//
//  Created by Savio Sailas on 08/08/26.
//

import SwiftUI

struct TransactionItemView: View {
    
    @State var showDetails: Bool = false
    let vm: TransactionItemViewModel
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading, spacing: 0.0, content: {
            
            HStack(alignment: .center, spacing: 0.0, content: {
                
                Text(verbatim: vm.transactionIcon)
                    .font(.caption)
                    .foregroundStyle(vm.iconColor)
                    .padding(.trailing, 1.5)
                
                Text(verbatim: vm.displayAmount)
                    .font(.title2)
                    .foregroundStyle(Color("textPrimary", bundle: .module))
                Spacer()
                Text(vm.name)
                    .font(.callout)
                    .foregroundStyle(Color("textPrimary", bundle: .module))
            })

            
            
            HStack(alignment: .bottom, spacing: 0.0, content: {
                
                Text(verbatim: "")
                
                Spacer()
                
                Text(verbatim: vm.date)
                    .font(.caption2)
                    .foregroundStyle(Color("textSecondary", bundle: .module))
            })
            
            if showDetails {
                HStack(alignment: .bottom, spacing: 0.0, content: {
                    
                    Text("")
                    
                    Spacer()
                    
                    Text(vm.time)
                        .font(.caption2)
                        .foregroundStyle(Color("textPrimary", bundle: .module))
                })
            }
            
            
        })
        .frame(minHeight: 70.0)
        .padding(.horizontal, 10.0)
        .background(content: {
            Color("primaryBG", bundle: .module)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
        })
        .overlay(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(Color.gray, lineWidth: 0.1)
                .shadow(radius: 12.0)
        })
        .allowsHitTesting(true)
        .onTapGesture {
            showDetails.toggle()
        }
        .padding(.horizontal, 10.0)
        
    }
}

#Preview {
    List(1...5, id: \.self) { _ in
        TransactionItemView(vm: TransactionItemViewModel(
            type: .debit, name: "Food",
            date: "12 July 2026", time: "3.30 pm", amount: 10.0)
        )
    }
}
