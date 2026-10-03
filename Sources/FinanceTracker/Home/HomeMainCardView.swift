//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 02/08/26.
//

import SwiftUI

struct HomeMainCardView: View {
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        HStack(alignment: .center, content: {
            
            VStack(alignment: .leading, spacing: 0.0, content: {
                Text(verbatim: "4,23,453")
                    .font(.title)
                    .foregroundStyle(Color("textPrimary", bundle: .module))
                Text("Balance")
                    .font(.caption)
                    .foregroundStyle(Color("textSecondary", bundle: .module))
                
                // Expense / income info
                
                DisclosureGroup(isExpanded: $isExpanded, content: {
                    VStack(alignment: .leading, spacing: 5.0, content: {

                        HStack(alignment: .center, content: {
                            Text("Spend this month")
                                .font(.callout)
                                .foregroundStyle(Color("textSecondary", bundle: .module))
                            Spacer()
                            Text(verbatim: "5,024")
                        })
                        
                        HStack(alignment: .center, content: {
                            Text("Income this month")
                                .font(.callout)
                                .foregroundStyle(Color("textSecondary", bundle: .module))
                            Spacer()
                            Text(verbatim: "54,000")
                        })
                    })
                }, label: {
                    EmptyView()
                })
                .disabled(true)
                .labelsHidden()

            })
            
            Spacer()
            
        })
        .padding(10)
        .background(content: {
            Color("primaryBG", bundle: .module)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
        })
        
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .inset(by: -2)
                .stroke(Color.orange, lineWidth: 1)
            ,
            alignment: .center)
        		
        .allowsHitTesting(true)
        .onTapGesture {
            isExpanded.toggle()
        }
        .padding()
    }
}

#Preview {
    HomeMainCardView()
}
