import SwiftUI

struct ContentView: View {
   
    @State var viewModel = ViewModel()

    var body: some View {
        ScrollView(.vertical, content: {
            HeaderView(action: {})
            StatusCardView()
                .padding(.top, 20.0)
            
            HStack(alignment: .firstTextBaseline, content: {
                Text("Transactions")
                    .font(.title2)
                    .foregroundStyle(Color.black)
                Spacer()
            })
            .padding(.top, 20.0)
            .padding(.leading, 10.0)
            ForEach(1...10, id: \.self) { _ in
                DebitListView()
            }
            
        })
    }
}
