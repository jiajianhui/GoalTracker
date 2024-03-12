//
//  IAP.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/15.
//

import SwiftUI

struct IAP: View {
    
    @State var showPurchase: Bool = false
    
    @AppStorage("isPurchased") var isPurchased: Bool = false
    
    //1、 创建Store实体
    @StateObject var store = Store()
    
    var body: some View {
        
        VStack {
            if isPurchased {  //若购买，则显示该内容
                VStack {
                    Image("icon01")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    
                    ProInfo(title: NSLocalizedString("恭喜升级为Pro🎉", comment: "pro"), subTitle: "")
                    
                    showProBto
                }
                .cardStyle()
                .sheet(isPresented: $showPurchase, content: {
                    PurchaseView()
                        .presentationDragIndicator(.visible)
                })
                
            } else {  //若没购买，显示购买按钮（价格），恢复购买按钮
                VStack(spacing: 20) {
                    header
                    ProInfo(title: NSLocalizedString("开启新高度", comment: "pro"), subTitle: NSLocalizedString("解锁全部功能，保持创造，提高动力", comment: "proSubTitle"))
                    //2、 依次读取已经存在的所有内购选项
                    ForEach(store.storeProducts) { product in
                        VStack(spacing: 14) {
                            Button {
                                Task {
                                    try await store.purchase(product)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary)
                                    .frame(height: 64)
                                    .overlay {
                                        VStack(spacing: 4) {
                                            Text("立即解锁")
                                                .fontWeight(.bold)
                                            Text("\(product.displayPrice)  一次购买，永久持有")
                                                .font(.system(size: 12))
                                                .opacity(0.8)
                                        }
                                        .foregroundStyle(Color("btnTextColor"))
                                    }
                            }
                            subBtn
                        }
                        .onChange(of: store.purchasedCourses) { _ in
                            Task {
                                isPurchased = (try? await store.isPurchased(product)) ?? false
                            }
                        }
                    }
                    
                    
                }
                .cardStyle()
                .sheet(isPresented: $showPurchase, content: {
                    PurchaseView()
                        .presentationDragIndicator(.visible)
                })
            }
        }
        
    }
}

//MARK: - 组件
struct ProInfo: View {
    
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 26, weight: .heavy))
            Text(subTitle)
                .fontWeight(.medium)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .opacity(0.3)
        }
    }
}

//MARK: - 扩展组件
extension IAP {
    private var header: some View {
        HStack(spacing: 6) {
            Text("GoalCraft")
                .fontWeight(.medium)
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
    
    //未购买成功后，查看详情
    private var subBtn: some View {
        Button {
            showPurchase.toggle()
        } label: {
            Text("查看详情")
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundStyle(Color.primary)
        }
    }
    
    //购买成功后，查看详情按钮
    private var showProBto: some View {
        Button {
            showPurchase.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primary)
                .frame(height: 64)
                .overlay {
                    Text("查看详情")
                        .fontWeight(.bold)
                        .foregroundStyle(Color("btnTextColor"))
                }
        }
    }
    
    
}

#Preview {
    IAP()
        .environment(\.locale, Locale(identifier: "en"))
}
