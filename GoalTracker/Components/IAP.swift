//
//  IAP.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/15.
//

import SwiftUI

struct IAP: View {
    
    @State var showPurchase: Bool = false
    
    //1、 创建Store实体
    @StateObject var store = Store()
    
    var body: some View {
        //2、 依次读取已经存在的所有内购选项
        ForEach(store.allProducts, id: \.self) { product in
            if !product.isLocked {  //若购买，则显示该内容
                Text("已解锁Pro版本")
            } else {  //若没购买，显示购买按钮（价格），恢复购买按钮
                if let price = product.price, product.isLocked {
                    VStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Text("GoalTracker")
                                .fontWeight(.medium)
                            Text("Pro")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(2)
                                .padding(.horizontal, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 50)
                                }
                        }
                        VStack(spacing: 6) {
                            Text("开启新高度")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                            Text("解锁全部功能，保持创造，提高动力")
                                .fontWeight(.medium)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .opacity(0.3)
                        }
                        VStack(spacing: 14) {
                            Button {
                                if let product = store.product(for: product.id) {
                                    store.purchaseProduct(product)  //Store中的购买函数
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary)
                                    .frame(height: 64)
                                    .overlay {
                                        VStack(spacing: 4) {
                                            Text("立即解锁")
                                                .fontWeight(.bold)
                                            Text("\(price)  一次购买，永久持有")
                                                .font(.system(size: 12))
                                                .opacity(0.8)
                                        }
                                        .foregroundStyle(Color.white)
                                    }
                            }
                            Button {
                                showPurchase.toggle()
                            } label: {
                                Text("查看详情")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundStyle(Color.primary)
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
        //3、 该视图出现时，刷新内购状态
        .onAppear {
//            store.loadStoredPurchases()
        }
    }
}

#Preview {
    IAP()
}
