//
//  GoalModel.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import Foundation
import CoreData

//自己创建模型管理数据，这里的名称最好与Entity的名称一致
class GoalModel: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var schedule: Int
    @NSManaged var date: Date
    
    //添加默认值
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date(), forKey: "date")
        setPrimitiveValue(0, forKey: "schedule")
    }
    
    //空Goal
    static func empty(context: NSManagedObjectContext = CoreDataManager.shared.newContext) -> GoalModel {
        GoalModel(context: context)
    }
    
    //验证输入是否合法
    var isVaild: Bool {
        //trimmingCharacters去除字符串开头和结尾的空格和换行符
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

extension GoalModel {
    
    //查询CoreData
    private static var goalsFetchRequest: NSFetchRequest<GoalModel> {
        NSFetchRequest(entityName: "GoalModel")
    }
    
    //对返回的结果排序
    static func all() -> NSFetchRequest<GoalModel> {
        let request: NSFetchRequest<GoalModel> = goalsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \GoalModel.date, ascending: true)
        ]
        return request
    }
    
    //筛选
    static func filter(with config: FilterConfig) -> NSPredicate {
        switch config.filter {
        case .all:
            return NSPredicate(value: true)
        case.complete:
            return NSPredicate(format: "schedule == 10", NSNumber(value: true))
        case .unfinish:
            return NSPredicate(format: "schedule != 10", NSNumber(value: true))
        }
    }
}

