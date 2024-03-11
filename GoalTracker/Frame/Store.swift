//
//  Store.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/15.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification   // 验证失败
}

class Store: ObservableObject {
    // 如果有多种产品类型，则为每种 .consumable（可消耗）, .nonconsumable（不可消耗）, .autoRenewable（自动更新）, .nonRenewable（非自动更新）创建多个变量。
    @Published var storeProducts: [Product] = []  // 商店中的产品列表
    @Published var purchasedCourses : [Product] = []  // 已购买的课程列表
    
    var updateListenerTask: Task<Void, Error>? = nil   // 更新监听任务
    
    // 维护一个产品列表
    private let productDict: [String : String]
    init() {
        // 检查产品列表的路径
        if let plistPath = Bundle.main.path(forResource: "ProductList", ofType: "plist"),
           // 获取产品列表
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String : String]) ?? [:]
        } else {
            productDict = [:]
        }
        
        // 尽可能接近应用启动的时候开始监听事务，以避免错过任何事务
        updateListenerTask = listenForTransactions()
        
        // 创建异步操作
        Task {
            await requestProducts()  // 请求产品列表
            
            // 传递给客户购买的产品
            await updateCustomerProductStatus()  // 更新客户产品的状态
        }
    }
    
    // 当退出或关闭应用时，停止监听事务
    deinit {
        updateListenerTask?.cancel()
    }
    
    // 开始在应用启动早期就监听事务
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // 遍历所有不是通过直接调用 'purchase()' 获取的事务
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    // 事务验证成功，将内容提供给用户
                    await self.updateCustomerProductStatus()
                    
                    // 始终完成一项事务
                    await transaction.finish()
                } catch {
                    // StoreKit 有一个事务验证失败，不向用户提供内容
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    // 在后台请求产品
    @MainActor
    func requestProducts() async {
        do {
            // 使用 Product 静态方法 products 来获取产品列表
            storeProducts = try await Product.products(for: productDict.values)
            
            // 遍历 "type"，如果有多种产品类型的话。
        } catch {
            print("Failed - error retrieving products \(error)")
        }
    }
    
    
    // 检查：所有的验证结果
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // 检查 JWS 是否通过了 StoreKit 验证
        switch result {
        case .unverified:
            // 验证失败
            throw StoreError.failedVerification
        case .verified(let signedType):
            // 结果验证成功，返回已解包的值
            return signedType
        }
    }
    
    // 更新客户的产品
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedCourses: [Product] = []
        
        // 遍历所有用户购买的产品
        for await result in Transaction.currentEntitlements {
            do {
                // 再次检查事务是否验证通过
                let transaction = try checkVerified(result)
                // 因为我们只有一种产品类型 - .nonconsumables 如果 storeProducts 中有任何产品的ID与事务的 productID 匹配，则添加到 purchasedCourses
                if let course = storeProducts.first(where: { $0.id == transaction.productID}) {
                    purchasedCourses.append(course)
                }
                
            } catch {
                // storekit有一个事务未通过验证，不向用户提供内容
                print("Transaction failed verification")
            }
            
            // 最后分配已购买的产品
            self.purchasedCourses = purchasedCourses
        }
    }
    
    // 购买产品
    func purchase(_ product: Product) async throws -> Transaction? {
        // 发出购买请求 - 可选参数可用
        let result = try await product.purchase()
        
        // 检查结果
        switch result {
        case .success(let verificationResult):
            // 使用 JWT(jwsRepresentation)自动验证交易，我们可以检查结果
            let transaction = try checkVerified(verificationResult)
            
            // 交易已验证，将内容提供给用户
            await updateCustomerProductStatus()
            
            // 始终完成交易 - 提高性能
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
        
    }
    
    // 检查产品是否已经购买
    func isPurchased(_ product: Product) async throws -> Bool {
        // 因为我们只有一种产品类型分组，即 .nonconsumable，我们检查这是否在已购买的课程中，
        // 这是在初始化（init）的时候运行的
        return purchasedCourses.contains(product)
    }
    
    
}
