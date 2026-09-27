//
//  SwiftUIView.swift
//  FinanceMobileApp
//
//  Created by user on 01/08/26.
//

import SwiftUI

struct GreetingsView: View {
    
    @AppStorage("username") var userName: String = ""
    @State private var timeOfDay: String = ""
    
    let action: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, content: {
            VStack(alignment: .leading, content: {
                HStack(alignment: .center, content: {
                    Text("Hi")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.red)
                    Text(verbatim: userName)
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.gray)
                        .foregroundStyle(Color("TitleColor", bundle: .module))
                })
                
                Text(timeOfDay)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            })
            
            Spacer()
            
//            Button(action: {
//                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                action?()
//            },
//            label: {
//                Image("settings", bundle: .module, label: Text("Settings"))
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 34)
//            })
//            .clipShape(Circle())
//            #if SKIP
//            .material3Ripple { options in
//                let updatedOption = options ?? Material3RippleOptions()
//                updatedOption.color = androidx.compose.ui.graphics.Color(color = 0xFFFF0000)
//                return updatedOption
//            }
//            #endif
        })
        .padding([.horizontal, .top])
        .onAppear {
            updateTimeOfDay()
        }
    }
    
    private func updateTimeOfDay() {
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 0..<12:
                timeOfDay = "Good morning"
            case 12..<17:
                timeOfDay = "Good afternoon"
            default:
                timeOfDay = "Good evening"
            }
        }
    
}

#if !SKIP
#Preview {
    VStack(alignment: .center, content: {
        GreetingsView(action: nil)
        Spacer()
    })
}
#endif
