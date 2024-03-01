//
//  GoalTrackerApp.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI
import UserNotifications

@main
struct GoalTrackerApp: App {
    
    //记录初次打开应用，防止重复调用通知
    @AppStorage("firstLaunch") var firstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GoalListView()
                    .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
                    .environmentObject(AppSettings())
                    .onAppear {
                        NotificationManager().requestNotificationAuthorization()
                        
                        if firstLaunch {
                            firstLaunch = false
                            NotificationManager().toggleNotification()
                        }
                    }
                
                LaunchView()
            }
            
        }
    }
}
