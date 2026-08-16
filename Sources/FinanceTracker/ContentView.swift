import SwiftUI

struct ContentView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, content: {
                HeaderView(action: {})
                StatusCardView()
                    .padding(.top, 20.0)
                
                NavigationLink(value: "AddEvent") {
                    
                    HStack(alignment: .firstTextBaseline, content: {
                        Spacer()
                        Text(verbatim: "AddEvent")
                            .font(.title2)
                            .foregroundStyle(Color("titleColor", bundle: .module))
                            .padding(.horizontal)
                            .padding(.vertical, 5.0)
                            .background(Color("primaryBG", bundle: .module))
                            .clipShape(Capsule(style: .continuous))
//                        Spacer()
                    })
                    
                }
                HStack(alignment: .firstTextBaseline, content: {
                    Text(verbatim: "April 2026")
                        .font(.title2)
                        .foregroundStyle(Color("textPrimary", bundle: .module))
                    Spacer()
                })
                .padding(.top, 20.0)
                .padding(.leading, 10.0)
                .padding(.bottom)
                if viewModel.transactions.isEmpty {
                    Text("No transactions")
                        .font(.largeTitle)
                        .foregroundStyle(Color("textSecondary", bundle: .module))
                }
                ForEach(viewModel.transactions, id: \.self) { transaction in
                    TransactionItemView(vm: transaction)
                }
                
                HStack {
                    Spacer()
                    NavigationLink(value: "history") {
                        Text(verbatim: " View all")
                            .padding()
                            .foregroundStyle(Color("textPrimary", bundle: .module))
                            .background(Color("titleColor", bundle: .module))
                            .clipShape(Capsule(style: .continuous))
                    }
                    Spacer()
                }
                
            })
            
            .onAppear {
                #if DEBUG
                print("Home page visble")
                #endif
            }
            
            .navigationDestination(for: String.self) { value in
                
                switch value {
                case "history":
                    Text("History view")
                case "AddEvent":
                    AddTransactionView()
                default:
                    EmptyView()
                }
                
            }
            
        }
    }
}
