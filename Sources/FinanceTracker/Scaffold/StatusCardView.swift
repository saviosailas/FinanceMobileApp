//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 02/08/26.
//

import SwiftUI

struct StatusCardView: View {
    
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
                
                // Expanse / income info
                
                DisclosureGroup(isExpanded: $isExpanded, content: {
                    VStack(alignment: .leading, spacing: 5.0, content: {
                        Divider()

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
                .labelsHidden()

            })
            
            Spacer()
            
        })
        .padding(10)
        .background(content: {
//            Color("TitleColor", bundle: .module).opacity(0.6)
//                .clipShape(RoundedRectangle(cornerRadius: 12.0))
            Color("primaryBG", bundle: .module).clipShape(RoundedRectangle(cornerRadius: 12.0))
                .overlay(Color.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 12.0).inset(by: -2).stroke(lineWidth: 1))
        })
//        .contentShape(RoundedRectangle(cornerRadius: 12.0))
        .allowsHitTesting(true)
        .onTapGesture {
            isExpanded.toggle()
        }
        .padding()
    }
}

#Preview {
    StatusCardView()
}
