//
//  PurchaseView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/15.
//

import SwiftUI

struct PurchaseView: View {
    
    //环境变量，关闭当前弹窗
    @Environment(\.dismiss) private var dismiss
    
    //1、 创建Store实体
    @StateObject var store = Store()
    
    var body: some View {
        
        //2、 依次读取已经存在的所有内购选项
        ForEach(store.allProducts, id: \.self) { product in
            if !product.isLocked {  //若购买，则显示该内容
                
            } else {
                if let price = product.price, product.isLocked {
                    VStack {
                        VStack(spacing: 50) {
                            purchaseHeader
                            
                            purchaseInfo
                            
                            VStack(spacing: 20) {
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
                                
                                HStack(spacing: 24) {
                                    Button {
                                        
                                    } label: {
                                        Text("使用协议")
                                    }
                                    Button {
                                        
                                    } label: {
                                        Text("隐私政策")
                                    }
                                    Button {
                                        store.restorePurchases()
                                    } label: {
                                        Text("恢复购买")
                                    }
                                }
                                .font(.system(size: 14))
                                .opacity(0.4)
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                }
                
            }
        }
        //3、 该视图出现时，刷新内购状态
        .onAppear {
            store.loadStoredPurchases()
        }
        
    }
}


//MARK: - 组件
struct Advantage: View {
    
    var title: String
    var subTitle: String
    var icon: String
    
    var body: some View {
        HStack(alignment: .top) {
            
            Image(systemName: icon)
                .foregroundStyle(Color.green)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                Text(subTitle)
                    .font(.callout)
                    .opacity(0.5)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
}

//MARK:
extension PurchaseView {
    private var purchaseHeader: some View {
        VStack(spacing: -10) {
            Image("icon01")
            HStack {
                Text("GoalTracker")
                    .fontWeight(.bold)
                Text("Pro")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(2)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                    }
            }
            .font(.system(size: 28, weight: .bold))
        }
    }
    
    private var purchaseInfo: some View {
        VStack(spacing: 20) {
            Advantage(title: "创建无限目标", subTitle: "保持创造，提高动力", icon: "checkmark.seal.fill")
            Advantage(title: "设置自定义图标", subTitle: "选择你最喜欢的图标，后续会不断更新", icon: "checkmark.seal.fill")
            Advantage(title: "支持我的后续开发", subTitle: "你的支持是我最大的动力", icon: "checkmark.seal.fill")
        }
    }
    
}

#Preview {
    PurchaseView()
}
