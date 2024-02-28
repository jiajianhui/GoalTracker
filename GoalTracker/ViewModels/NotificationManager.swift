//
//  NotificationManager.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/27.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    
    @AppStorage("isNotificationEnabled") var isNotificationEnabled = true
    
    func toggleNotification() {
        if isNotificationEnabled {
            dailyNotification()
        } else {
            
        }
    }
    
    //通知权限
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("用户已授权通知")
            } else if let error = error {
                print("通知授权失败: \(error.localizedDescription)")
            }
        }
    }
    
    
    //每天通知函数
    func dailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "今日回顾"
        content.body = "查看你的目标进度"
        content.sound = UNNotificationSound.default
        
        //设置触发通知的时间
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        //创建通知触发器，每天定时触发
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //创建通知请求
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //将通知请求添加到用户通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知添加失败 \(error)")
            } else {
                print("每天自动通知添加成功")
            }
        }
        
    }
    
    //每周通知函数
    func weeklyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "本周回顾"
        content.body = "回顾过去一周的目标进度"
        content.sound = UNNotificationSound.default
        
        //设置触发通知的时间
        var dateComponents = DateComponents()
        dateComponents.weekday = 2
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        //创建通知触发器，每天定时触发
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //创建通知请求
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //将通知请求添加到用户通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知添加失败 \(error)")
            } else {
                print("每周自动通知添加成功")
            }
        }
        
    }
}
