//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 27/09/26.
//

import SwiftUI

struct AddTransactionView: View {
    
    @State var vm: AddTransactionViewModel = .init()
    
    var body: some View {
        VStack(alignment: .center, spacing: 12.0) {
            
            Label {
                HStack {
                    Text("")
                    Spacer()
                    TextField("0", text: $vm.amount)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 150.0)
                }
                .padding(12.0)
            } icon: {
                Text("Money")
                    .font(.title2)
            }
            
            Label {
                
                Picker(selection: $vm.selectedAccount) {
                    ForEach(vm.accountTypes, id: \.self) {
                        Text($0)
                            .font(.title2)
                            .padding(12.0)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.navigationLink)
            } icon: {
                Text("Account")
                    .font(.title2)
            }
            //            .labelStyle(.titleOnly)
            
            Label {
                Picker(selection: $vm.selectedTransferType) {
                    ForEach(vm.transferTypes, id: \.self) {
                        Text($0)
                            .font(.title2)
                            .padding(8.0)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
            } icon: {
                Text("Credit / Debit")
                    .font(.title2)
            }
                        .labelStyle(.titleOnly)
            
            Button {
                Task {
                    await vm.addButtonAction()
                }
            } label: {
                Text("Add new")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(
                        Color("primaryBG", bundle: .module)
                    )
                    .padding()
                    .background(
                        (vm.amount.isEmpty ? Color.gray : Color.blue)
                            .clipShape(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(
                                        topLeading: 14.0,
                                        bottomLeading: 0,
                                        bottomTrailing: 14.0,
                                        topTrailing: 0
                                    )
                                )
                            )
                    )
            }
            .padding(.vertical, 12.0)
            
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        AddTransactionView()
            .navigationTitle("New transaction")
    }
    
}

