//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 15/08/26.
//

import SwiftUI

struct AddEventView: View {
    
    @State var eventName: String = ""
    @State var amount: Double = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField(text: $eventName, prompt: Text("Ant prompt"), label: {})
            
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Credit")
                        .padding()
                })
            }
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Debit")
                        .padding()
                })
            }
            
            Spacer()
        }
    }
}

#Preview {
    AddEventView()
}
