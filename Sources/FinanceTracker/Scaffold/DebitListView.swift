//
//  DebitListView.swift
//  FinanceMobileApp
//
//  Created by user on 08/08/26.
//

import SwiftUI

struct DebitListView: View {
    
    @State var showDetails: Bool = false
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading, spacing: 0.0, content: {
            
            
            HStack(alignment: .center, spacing: 0.0, content: {
                Text("10,000")
                    .font(.title2)
                    .foregroundStyle(Color.primary)
                Spacer()
                Text("Food")
                    .font(.callout)
                    .foregroundStyle(Color.primary)
            })

            
            
            HStack(alignment: .bottom, spacing: 0.0, content: {
                
                Text("(-)")
                    .font(.caption2)
                    .foregroundStyle(Color.red)
                
                Spacer()
                
                Text("12 July 2026")
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            })
            
            if showDetails {
                HStack(alignment: .bottom, spacing: 0.0, content: {
                    
                    Text("")
                    
                    Spacer()
                    
                    Text("3: 13 pm")
                        .font(.caption2)
                        .foregroundStyle(Color.black)
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
        .onTapGesture {
            showDetails.toggle()
        }
        .padding(.horizontal, 10.0)
        
    }
}

#Preview {
    List(1...1, id: \.self) { _ in
        DebitListView()
    }
}
