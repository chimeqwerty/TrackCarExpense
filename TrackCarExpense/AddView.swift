//
//  AddView.swift
//  TrackCarExpense
//
//  Created by Jan Halas on 9.8.2024.
//

import SwiftUI
import Foundation

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var registerPlate = ""
    @State private var actionType = ""
    @State private var type = "Personal"
    @State private var amount: Double = 0.0
    @State private var currentUsrRegionCode = "EUR"
    
    var expenses: Expenses
    let types = ["Personal", "Business"]
    var currencyList = Locale.commonISOCurrencyCodes
    
    var body: some View {
        
        
        NavigationStack {
            
            
                    Picker("Select currency", selection: $currentUsrRegionCode) {
                        ForEach(currencyList, id: \.self) {
                            Text($0)
                        }
                    }
                
            
            
            Form {
                TextField("Register plate", text: $registerPlate)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("What have been done?", text: $actionType)
                TextField("Amount", value: $amount, format: .currency(code: currentUsrRegionCode ?? "USD"))
                    .keyboardType(.numberPad)
            }.navigationTitle("Add new expense")
                .toolbar {
                    Button("Add") {
                        let item = ExpenseItem(registrationPlate: registerPlate, actionType: actionType, type: type, amount: amount)
                        expenses.items.append(item)
                        dismiss() 
                    }
                }
        }
        }
}

#Preview {
    AddView(expenses: Expenses())
}
