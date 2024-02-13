//
//  GoalTrackerApp.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

@main
struct GoalTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            GoalListView()
                .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
                .environmentObject(AppSettings())
        }
    }
}
