//
//  ChangeIconView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/12.
//

import SwiftUI

struct ChangeIconView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(iconName.indices, id: \.self) { i in
                        Button {
                            appSettings.appIconSettings = i
                        } label: {
                            HStack {
                                HStack {
                                    Image(iconName[i])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80)
                                    Text(iconTitle[i])
                                }
                                Spacer()
                                Image(systemName: "heart")
                            }
                            .foregroundStyle(Color.primary)
                            .cardStyle()
                            .imageCheckStyle(check: appSettings.appIconSettings == i, cornerRadius: 24)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("换个图标")
            .frame(maxWidth: .infinity)
            .background {
                Color(uiColor: .systemGray6).ignoresSafeArea()
            }
        }
    }
}

//MARK: - 自定义修改器
struct ImageCheckedModifier: ViewModifier {
    
    var check: Bool
    var cornerRadius:CGFloat
    
    func body(content: Content) -> some View {
        if check {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color.primary, lineWidth: 2)
                )
        } else {
            content
        }
    }
    
}

extension View {
    func imageCheckStyle(check: Bool, cornerRadius: CGFloat = 8.0) -> some View {
        modifier(ImageCheckedModifier(check: check, cornerRadius: cornerRadius))
    }
}


#Preview {
    ChangeIconView()
        .environmentObject(AppSettings())
}
