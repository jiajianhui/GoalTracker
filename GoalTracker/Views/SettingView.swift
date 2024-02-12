//
//  SettingView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/5.
//

import SwiftUI

struct SettingView: View {
    
    @State var sss = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Text("GoalTracker")
                                .fontWeight(.medium)
                            Text("Pro")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(2)
                                .padding(.horizontal, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                }
                        }
                        VStack(spacing: 10) {
//                            Text("解锁全部功能")
//                                .font(.title3)
//                                .fontWeight(.bold)
                            Text("无限目标，iCloud数据同步")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primary)
                                .frame(height: 56)
                                .overlay {
                                    Text("立即解锁")
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                }
                        }
                        Button {
                            
                        } label: {
                            Text("了解详情")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .cardStyle()
                    
                    VStack(spacing: 20) {
                        SettingRowView(icon: "Pro", title: "会员类型", showArrow: false, showInfo: true)
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(Color.primary)
                                .frame(height: 60)
                                .overlay {
                                    Text("解锁Pro版")
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                }
                        }
                    }
                    .cardStyle()
                    
                    VStack(spacing: 32) {
                        Button {
                            
                        } label: {
                            SettingRowView(icon: "图标", title: "换个图标", info: "默认", showInfo: true)
                        }
                        Toggle(isOn: $sss, label: {
                            HStack {
                                Image("同步")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 22)
//                                    .opacity(0.3)
                                Text("iCloud同步")
                                    .fontWeight(.medium)
                            }
                        })
                        .tint(.primary)
                        
                    }
                    .cardStyle()
                    
                    VStack(spacing: 32) {
                        Button {
                            
                        } label: {
                            SettingRowView(icon: "好评", title: "给个好评", showInfo: false)
                        }
                        Button {
                            
                        } label: {
                            SettingRowView(icon: "分享", title: "分享给朋友", showInfo: false)
                        }
                        Button {
                            
                        } label: {
                            SettingRowView(icon: "反馈", title: "意见反馈", showInfo: false)
                        }
                        Button {
                            
                        } label: {
                            SettingRowView(icon: "隐私", title: "隐私政策", showInfo: false)
                        }
                    }
                    .cardStyle()
                    
                    VStack(alignment: .leading) {
                        Text("Design by ")
                            .font(.system(size: 14, weight: .regular))
                            .opacity(0.3)
                        Text("JianHui")
                            .font(.system(size: 15, weight: .medium, design: .serif))
                    }
                    VStack(alignment: .leading) {
                        Text("版本 1.0 ")
                            .font(.system(size: 14, weight: .regular))
                    }
                }
                .padding()
                
                
            }
            .frame(maxWidth: .infinity)
            .background {
                Color(uiColor: .systemGray6).ignoresSafeArea()
            }
            
            .navigationTitle("设置")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


//MARK: - 样式组件
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(20)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.white)
            }
    }
}

//扩展View来创建新函数，方便使用modifier
extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

#Preview {
    SettingView()
}
