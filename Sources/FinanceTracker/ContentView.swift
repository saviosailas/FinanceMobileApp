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
                        Spacer()
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
                ForEach(viewModel.transactions, id: \.self) { transaction in
                    TransactionItemView(vm: transaction)
                }
                
            })
            
            .onAppear {
                print("Home page visble")
            }
            
            .navigationDestination(for: String.self) { value in
                Text("Add event / edit / update")
            }
            
        }
    }
}
