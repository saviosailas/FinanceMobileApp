import SwiftUI

struct ContentView: View {
   
    @State var viewModel = ViewModel()

    var body: some View {
        ScrollView(.vertical, content: {
            HeaderView(action: {})
        })
    }
}
