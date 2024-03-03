//
//  CoreDataManager.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import Foundation
import SwiftUI
import CoreData

//主要负责在CoreData中加载和管理数据
class CoreDataManager {
    
    //自身初始化
    static let shared = CoreDataManager()
    
    //创建容器，支持本地和网络存储
    private let container: NSPersistentCloudKitContainer
    
    //创建上下文
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    //创建新的上下文，方便后面的编辑和添加
    var newContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    
    //启动方法
    init() {
        container = NSPersistentCloudKitContainer(name: "GoalModel")  //创建容器，名称必须与模型名称一致
        
        //widget相关
        let url = URL.storeURL(for: "group.com.jjh.GoalTracker", databaseName: "GoalModel")
        let storeDescription = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.viewContext.automaticallyMergesChangesFromParent = true  //viewContext变化时，自动保存
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("无法加载数据 \(error)")
            }
        }
    }
    
    
}

extension CoreDataManager {
    func exists(_ goal: GoalModel, in context: NSManagedObjectContext) -> GoalModel? {
        try? context.existingObject(with: goal.objectID) as? GoalModel
    }
    
    func delete(_ goal: GoalModel, in context: NSManagedObjectContext) {
        if let existingGoal = exists(goal, in: context) {
            context.delete(existingGoal)
            try? context.save()
        }
    }
}

//widget相关
public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("不能创建URL \(appGroup)")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
