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
            cancelNotification()
        }
    }
    
    //通知权限
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.toggleNotification()  //只有用户授权通知权限后，才执行该函数（添加通知）
                print("用户已授权通知")
            } else if let error = error {
                print("通知授权失败: \(error.localizedDescription)")
            }
        }
    }
    
    
    //每天通知函数
    func dailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("今日回顾", comment: "notificationTitle")
        content.body = NSLocalizedString("查看你的目标进度", comment: "notificationSubTitle")
        content.sound = UNNotificationSound.default
        
        //设置触发通知的时间
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        //创建通知触发器，每天定时触发
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //创建通知请求
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        //将通知请求添加到用户通知中心，检查是否已经存在相同标识符的通知请求
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let extistingRequest = requests.first { $0.identifier == "dailyNotification" }
            
            //如果不存在相同标识符的通知请求则添加通知，否则不添加
            if extistingRequest == nil {
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("每天通知添加失败 \(error)")
                    } else {
                        print("每天通知添加成功")
                    }
                }
            } else {
                print("每天通知已存在")
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
        let request = UNNotificationRequest(identifier: "weeklyNotification", content: content, trigger: trigger)
        
        //将通知请求添加到用户通知中心，检查是否已经存在相同标识符的通知请求
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let extistingRequest = requests.first { $0.identifier == "weeklyNotification" }
            
            //如果不存在相同标识符的通知请求则添加通知，否则不添加
            if extistingRequest == nil {
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("每周通知添加失败 \(error)")
                    } else {
                        print("每周通知添加成功")
                    }
                }
            } else {
                print("每周通知已存在")
            }
            
        }
        
    }
    
    //取消通知函数
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
