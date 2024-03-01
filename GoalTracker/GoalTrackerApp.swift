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
    
    @StateObject var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                GoalListView()
                    .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
                    .environmentObject(AppSettings())
                
                    .onAppear {
                        notificationManager.requestNotificationAuthorization()  //请求通知权限
                    }
                
                LaunchView()
            }
            
        }
    }
}
