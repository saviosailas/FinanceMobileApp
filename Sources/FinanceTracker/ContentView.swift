import SwiftUI

struct ContentView: View {
   
    @State var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, content: {
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
                ForEach(1...10, id: \.self) { _ in
                    DebitCellView()
                        .padding(.bottom, 5.0)
                }
                
            })
            .navigationDestination(for: String.self) { link in
                AddTransactionView()
                    .navigationTitle("New transaction")
            }
        }
    }
}
