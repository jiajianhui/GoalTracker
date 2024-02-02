//
//  GoalListView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

struct GoalListView: View {
    
    //初始化CoreData
    var coreDataManager = CoreDataManager.shared
    
    //从数据库拿数据
    @FetchRequest(fetchRequest: GoalModel.all()) var goals
    
    //当前选择的Goal
    @State var selectedGoal: GoalModel?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(goals) { goal in
                        GoalRowView(vm: .init(coreDataManager: coreDataManager, goal: goal), selectedGoal: $selectedGoal)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "sparkle")
                        Text("Goal List")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                }
            }
            .background {
                Color(uiColor: .systemGray6).opacity(0.5).ignoresSafeArea()
            }
            
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                UIImpactFeedbackGenerator.impact(style: .light)
                selectedGoal = GoalModel.empty()
            } label: {
                Circle()
                    .foregroundStyle(Color.primary)
                    .frame(width: 60)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                    }
                    .padding(30)
                    .shadow(color: .primary.opacity(0.2), radius: 14, x: 0.0, y: 8)
            }
        }
        .sheet(item: $selectedGoal) {
            selectedGoal = nil
        } content: { goal in
            AddAndEditGoalView(vm: .init(coreDataManager: coreDataManager, goal: goal))
                .presentationDetents([.medium, .large])
        }

    }
}

#Preview {
    GoalListView()
}
