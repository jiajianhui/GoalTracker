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
    var body: some Scene {
        WindowGroup {
            GoalListView()
                .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
                .environmentObject(AppSettings())
                .onAppear {
                    requestNotificationAuthorization()
                    if NotificationManager().isNotificationEnabled {
                        NotificationManager().toggleNotification()
                    } else {
                        
                    }
                }
        }
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("用户已授权通知")
            } else if let error = error {
                print("通知授权失败: \(error.localizedDescription)")
            }
        }
    }

}
