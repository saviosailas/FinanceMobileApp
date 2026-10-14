//
//  DebitCellView.swift
//  FinanceMobileApp
//
//  Created by user on 08/08/26.
//

import SwiftUI

struct DebitCellView: View {
    
    @State var showDetails: Bool = false
    
    var amount: Double
    var account: String
    var type: String
    var date: Date
    var note: String
    
    var body: some View {
        // 1. The main container that holds the background and border
        VStack(alignment: .leading, spacing: 0) {
            
            // --- Header Section (Stationary) ---
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0.0) {
                    Text(amount.description)
                        .font(.title)
                        .foregroundStyle(type == TransactionType.debit.rawValue ? Color.red : Color.primary)
                    
                    Spacer()
                    
                    Text(account)
                        .font(.callout)
                        .foregroundStyle(Color.primary)
                }
                
                HStack(alignment: .bottom, spacing: 0.0) {
                    Spacer()
                    
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                }
            }
            .padding(.bottom, 8) // Space between header and the expanding details
            
            // --- Details Section (Expands downwards) ---
            if showDetails {
                HStack(alignment: .bottom, spacing: 0.0) {
                    Text(note)
                    
                    Spacer()
                    
                    Text(date.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(Color.black)
                }
                // This transition makes it slide down from the header instead of just appearing
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        // 2. Content Padding: Space between the card edges and the text
        .padding(.horizontal, 15.0)
        .padding(.vertical, 12.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color("primaryBG", bundle: .module)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(Color.gray, lineWidth: 0.1)
                .shadow(radius: 12.0)
        )
        .onTapGesture {
            // 3. Use a spring animation for a more natural "expansion" feel
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showDetails.toggle()
            }
        }
        // 4. External Padding: Space between the card and the screen/list edges
        .padding(.horizontal, 10.0)
    }
}
