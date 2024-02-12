//
//  SettingRowView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/5.
//

import SwiftUI

struct SettingRowView: View {
    
    var icon: String
    var title: String
    var info: String = "免费"
    
    var showArrow: Bool = true
    var showInfo: Bool = false
    
    
    
    var body: some View {
        
        HStack {
            HStack {
                Image(icon)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 22)
//                    .opacity(0.3)
                Text(title)
                    .fontWeight(.medium)
            }
            Spacer()
            
            HStack(spacing: 0) {
                if showInfo {
                    Text(info)
                        .font(.callout)
                }
                if showArrow {
                    Image("Arrow")
                }
            }
            .opacity(0.3)
        }
        .foregroundStyle(Color.primary)
    }
}

#Preview {
    SettingRowView(icon: "Setting", title: "会员类型", showInfo: true)
}
