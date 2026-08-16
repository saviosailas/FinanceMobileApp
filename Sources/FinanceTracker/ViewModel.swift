import Foundation
import Observation


/// The Observable ViewModel used by the application.
@Observable public class ViewModel {
    
    
    var transactions: [TransactionItemViewModel] = [
         TransactionItemViewModel(
            type: .debit, name: "Food", date: "30 July 2026", time: "3.30 pm", amount: 100.0
         ),
         TransactionItemViewModel(
            type: .debit, name: "Car", date: "22 July 2026", time: "3.30 pm", amount: 480.0
         ),
         TransactionItemViewModel(
            type: .debit, name: "Home", date: "12 July 2026", time: "3.30 pm", amount: 5000.0
         ),
         TransactionItemViewModel(
            type: .debit, name: "Bike", date: "10 July 2026", time: "3.30 pm", amount: 8000.0
         ),
         TransactionItemViewModel(
            type: .credit, name: "Gold", date: "1 July 2026", time: "3.30 pm", amount: 27000.0
         ),
    ]
}
