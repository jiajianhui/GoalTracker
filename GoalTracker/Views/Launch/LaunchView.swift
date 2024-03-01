//
//  LaunchView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/3/1.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var showAnimation: Bool = false
    
    @State private var iconName: String?
    
    var body: some View {
        ZStack {
            Color("LaunchBgColor").ignoresSafeArea()
            if let iconName = iconName {
                Image(String(iconName.dropFirst(4)))  //移除字符串前四位
                    .resizable()
                    .scaledToFit()
                    .frame(width: 216)
                    .scaleEffect(showAnimation ? 20 : 1)
                    .offset(x: 0, y: -30)
            } else {
                Image("icon01")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 216)
                    .scaleEffect(showAnimation ? 20 : 1)
                    .offset(x: 0, y: -30)
            }
            
        }
        .opacity(showAnimation ? 0 : 1)
        
        .onAppear {
            getCurrentIconName()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.easeOut(duration: 0.7)) {
                    showAnimation = true
                }
            }
        }
    }
    
    //获取当前AppIocn
    func getCurrentIconName() {
        if let currentIconName = UIApplication.shared.alternateIconName {
            iconName = currentIconName
        } else {
            
        }
    }
}

#Preview {
    LaunchView()
}
