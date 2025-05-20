//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by June Hong on 2025-05-20.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context    // Key Point
    @State private var isShowingItemSheet: Bool = false
//    @Query(filter: #Predicate<Expense> { $0.value > 1000}) var expenses: [Expense] // Key Point
    @Query(sort: \Expense.date) var expenses: [Expense] // Key Point
    @State private var editExpense: Expense? // Key Point
    
    var body: some View {
        NavigationStack
        {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                        .onTapGesture {
                            editExpense = expense
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(expenses[index])
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $editExpense) { expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button("Add Expense") { isShowingItemSheet = true }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpenseCell: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "CAD"))
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.modelContext) var context    // Key Point
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text:$name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "CAD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense) // Key Point
                        
                        // Autosave will save, Just to make sure
                        try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: Expense  // Key Point
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text:$expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "CAD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
