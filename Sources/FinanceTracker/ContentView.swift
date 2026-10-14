import SwiftUI

struct ContentView: View {
    
    @State var viewModel = ViewModel()
    @Environment(SQLDatabase.self) var database
    
    var body: some View {
        NavigationStack {
            ScrollView(
                .vertical,
                content: {
                    HomeGreetingsView(action: {})
                    HomeMainCardView()
                        .padding(.top, 20.0)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        NavigationLink(value: "Add") {
                            Text("Add transaction")
                                .font(.title3)
                                .foregroundStyle(Color("textPrimary", bundle: .module))
                                .padding(7.0)
                                .background(
                                    Color("titleColor", bundle: .module).opacity(0.9)
                                        .clipShape(
                                            UnevenRoundedRectangle(cornerRadii: .init(
                                                topLeading: 40,
                                                bottomLeading: 40,
                                                bottomTrailing: 0,
                                                topTrailing: 0
                                            ), style: .continuous)
                                        )
                                )
                        }
                    }
                    
                    HStack(alignment: .firstTextBaseline, content: {
                        Text("Transactions")
                            .font(.title2)
                            .foregroundStyle(Color.black)
                        Spacer()
                    })
                    .padding(.top, 20.0)
                    .padding(.leading, 10.0)
                    
//                    List {
                        //                ForEach(1...10, id: \.self) { _ in
                        Section {
                            
                            
                            ForEach(database.transactionItem) { item in
                                DebitCellView(
                                    amount: item.amount,
                                    account: item.accountName,
                                    type: item.type,
                                    date: item.date,
                                    note: item.note
                                )
                                .padding(.bottom, 5.0)
                            }
                            .onDelete { indices in
                                database.deleteItems(atOffsets: Array(indices))
                            }
                            
                        }
//                    }
                    
                })
            .navigationDestination(for: String.self) { link in
                AddTransactionView()
                    .navigationTitle("New transaction")
            }
        }
    }
}
