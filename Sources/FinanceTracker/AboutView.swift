//
//  AboutView.swift
//  FinanceMobileApp
//
//  Created by user on 18/10/26.
//

import SwiftUI


struct AboutView: View {
    
    var body: some View {
        ZStack {
            Color.white
            
            
            Image("about", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(100)
            
            
//                .frame(maxWidth: 150.0)
            
//            Image(systemName: "heart.fill")
////                .renderingMode(.template)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: 30.0)
//                .foregroundStyle(
//                    LinearGradient(colors: [Color.red, Color.orange],
//                                   startPoint: .bottom,
//                                   endPoint: .leading)
//                )
//            
//            Text("Finance Tracker")
//            
//            Text("version 1.0.1")
//                .font(.caption)
            
            
            
        }
    }
}


#Preview {
    AboutView()
}
