//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 01/08/26.
//

import SwiftUI

struct HeaderView: View {
    
    let action: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, content: {
            Text("Finance")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color("TitleColor", bundle: .module))
            Spacer()
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                action?()
            },
            label: {
                Image("settings", bundle: .module, label: Text("Settings"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34)
            })
            .clipShape(Circle())
            #if SKIP
            .material3Ripple { options in
                let updatedOption = options ?? Material3RippleOptions()
                updatedOption.color = androidx.compose.ui.graphics.Color(color = 0xFFFF0000)
                return updatedOption
            }
            #endif
        })
        .padding([.horizontal, .top])
    }
}

#if !SKIP
#Preview {
    HeaderView(action: nil)
}
#endif
