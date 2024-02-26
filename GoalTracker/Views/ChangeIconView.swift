//
//  ChangeIconView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/12.
//

import SwiftUI

struct ChangeIconView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    
    //创建Store实体
    @StateObject var store = Store()
    
    //展示购买页
    @State private var showPurchase: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(iconName.indices, id: \.self) { i in
                        Button {
                            
                            //如果是会员，或者是第一个图标，则允许执行更换icon的操作
                            if store.purchased || i == 0 {
                                appSettings.appIconSettings = i
                            } else {
                                showPurchase.toggle()
                            }
                            
                        } label: {
                            HStack {
                                HStack {
                                    Image(iconName[i])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80)
                                    Text(iconTitle[i])
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                
                                //第一个默认图标不展示Pro标志
                                if i == 0 {
                                    
                                } else {
                                    //如果是会员，则不展示该标志
                                    if store.purchased {
                                        
                                    } else {
                                        proIcon
                                    }
                                }
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
            .sheet(isPresented: $showPurchase, content: {
                PurchaseView()
                    .presentationDragIndicator(.visible)
            })
            .onAppear {
                store.loadStoredPurchases()
            }
        }
    }
}

//MARK: - 自定义修改器，用于显示选择时出现描边
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

//MARK: - 组件
extension ChangeIconView {
    private var proIcon: some View {
        Text("Pro")
            .fontWeight(.bold)
            .foregroundStyle(Color("btnTextColor"))
            .padding(2)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(cornerRadius: 50)
            }
    }
}


#Preview {
    ChangeIconView()
        .environmentObject(AppSettings())
}
