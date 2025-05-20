//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by June Hong on 2025-05-20.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExampleApp: App {
    
//    let container: ModelContainer = {
//        let schema = Schema([Expense.self])
//        let container = try! ModelContainer(for: schema, configurations: [])
//        return container
//    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(container)
        .modelContainer(for: [Expense.self])
    }
}
