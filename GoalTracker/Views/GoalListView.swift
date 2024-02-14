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
    
    //设置
    @State var showSettingView = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(goals) { goal in
                        GoalRowView(vm: .init(coreDataManager: coreDataManager, goal: goal), selectedGoal: $selectedGoal)
                    }
                }
                .animation(.spring())
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    logo
                }
                ToolbarItem(placement: .topBarTrailing) {
                    settingLink
                }
            }
            .overlay(alignment: .bottomTrailing) {
                plusBtn
            }
            .background {
                Color(uiColor: .systemGray6).opacity(0.5).ignoresSafeArea()
            }
            
        }
        .sheet(item: $selectedGoal) {
            selectedGoal = nil
        } content: { goal in
            AddAndEditGoalView(vm: .init(coreDataManager: coreDataManager, goal: goal))
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSettingView, content: {
            SettingView()
        })

    }
}

//MARK: - 视图组件
extension GoalListView {
    
    //MARK: toolbar
    private var logo: some View {
        HStack {
            Image(systemName: "sparkle")
            Text("Goal List")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(Color.primary)
    }
    
    private var settingSheet: some View {
        Button {
            showSettingView.toggle()
        } label: {
            Image("Setting")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
    
    private var settingLink: some View {
        NavigationLink(destination: SettingView()) {
            Image("Setting")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }
    
    //MARK: 添加按钮
    private var plusBtn: some View {
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
}

#Preview {
    GoalListView()
        .environmentObject(AppSettings())
}
