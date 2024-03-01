//
//  ThemeData.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/12.
//

import SwiftUI


//MARK: - icon数据
let iconName: [String] = [
    "icon01",
    "icon02",
    "icon03",
    "icon04"
]
let iconTitle: [String] = [
    "默认",
    "钛元素",
    "奶油",
    "抽象"
]

//MARK: - icon选择设置
class AppSettings: ObservableObject {
    
    @Published var appIconSettings: Int = UserDefaults.standard.integer(forKey: "appIcon") {
        didSet {
            UserDefaults.standard.set(self.appIconSettings, forKey: "appIcon")
            UIApplication.shared.setAlternateIconName("App_\(iconName[self.appIconSettings])" )  //当appIconSetting数值变化时，会触发这个设置；点击第一个时（0）会为nil，使用默认icon
        }
    }
}

