//
//  AddAndEditViewModel.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import Foundation
import SwiftUI
import CoreData

class AddAndEditViewModel: ObservableObject {
    
    @Published var goal: GoalModel
    
    private let context: NSManagedObjectContext
    private let coreDataManager: CoreDataManager
    
    var isNew: Bool  //判断是否为新数据
    
    init(coreDataManager: CoreDataManager, goal: GoalModel? = nil) {
        self.context = coreDataManager.newContext
        self.coreDataManager = coreDataManager
        
        //判断是否存在该项目
        if let goal,
        let existingGoal = coreDataManager.exists(goal, in: context) {
            self.goal = existingGoal
            self.isNew = false
        } else {
            self.goal = GoalModel(context: self.context) //发布的goal在新的上下文中
            self.isNew = true
        }
    }
    
    
    //保存更改
    func save() {
        if context.hasChanges {  //如果有更改，就执行保存，性能更好
            try? context.save()
        }
    }
}
