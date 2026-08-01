import SwiftUI

enum ContentTab: String, Hashable {
    case welcome, home, settings
}

struct ContentView: View {
   
    @State var viewModel = ViewModel()

    var body: some View {
       Text("welcome")
    }
}
