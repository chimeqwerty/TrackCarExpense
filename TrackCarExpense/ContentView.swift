//
//  ContentView.swift
//  TrackCarExpense
//
//  Created by Jan Halas on 9.8.2024.
//

import SwiftUI


// Identifieable is used to generate a unique UUID's for each Expense-item user creates

//Codable is a framework that simplifies the process of converting between Swift objects and external data representations, like JSON
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let registrationPlate: String
    let actionType: String
    let type: String
    let amount: Double
}

// Observable macro is used to monitor real time & store ExpenseItem struct data attributes into "var items"
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        
        // encoding data from Swift array into JSON-data
        didSet {
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
                
            }
        }
    }
    // here, we're decoding data back from JSON format into readable Swift Array
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    // function to remove expense-items from the list
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    var body: some View {
        
    
                NavigationStack {
                    
                    
                    
                    
                    List {
                        
                        ForEach(expenses.items) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.registrationPlate)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.actionType)
                                
                                
                                Text(item.amount, format: .currency(code:Locale.current.currency?.identifier ?? "USD"))
                                
                                // color conditional formatting
                                    .foregroundColor(item.amount < 10 ? .green
                                                     : item.amount <= 100 ? .blue
                                                     : item.amount >= 100 ? .red
                                                     : .black)
                            }
                        }
                        .onDelete(perform: removeItems)
                        
                        
                    }.navigationTitle("CarExpenseTracker")
                        .toolbar {
                            Button("Add Cost", systemImage: "plus") {
                                showingAddExpense.toggle()
                            }
                        }.sheet(isPresented: $showingAddExpense) {
                            AddView(expenses: expenses)
                        }
                    
                }
            }
        }


#Preview {
    ContentView()
}
