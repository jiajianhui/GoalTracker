//
//  GoalListView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

//筛选配置项
struct FilterConfig: Equatable, Hashable {
    enum Filter {
        case all, unfinish, complete
    }
    
    var filter: Filter = .all
}

struct GoalListView: View {
    
    //初始化CoreData
    var coreDataManager = CoreDataManager.shared
    
    //从数据库拿数据
    @FetchRequest(fetchRequest: GoalModel.all()) var goals
    @FetchRequest(fetchRequest: GoalModel.complete()) var completeGoals
    @FetchRequest(fetchRequest: GoalModel.unFinish()) var unfinishGoals
    
    //当前选择的Goal
    @State var selectedGoal: GoalModel?
    
    //设置
    @State var showSettingView = false
    
    //展示购买信息
    @State var showStore = false
    
    @ObservedObject var store: Store
    
    init() {
        self.store = Store()
    }
    
    //筛选配置项
    @State private var num: Int = 0


    var body: some View {
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if goals.isEmpty && num == 0 {
                        EmptyGoalView(goalModel: $selectedGoal)
                            .offset(y: 40)
                            .transition(AnyTransition.opacity.animation(.easeOut))  //过渡动画
                    } else if unfinishGoals.isEmpty && num == 1 {
                        FilterView(goals: goals, num: $num)
                        Text("暂无进行中的目标")
                            .opacity(0.5)
                            .offset(y: 100)
                    } else if completeGoals.isEmpty && num == 2{
                        FilterView(goals: goals, num: $num)
                        Text("暂无已完成的目标")
                            .opacity(0.5)
                            .offset(y: 100)
                    } else {
                        FilterView(goals: goals, num: $num)
                        withAnimation(.spring()) {
                            ForEach(goals) { goal in
                                GoalRowView(vm: .init(coreDataManager: coreDataManager, goal: goal), selectedGoal: $selectedGoal)
                                    .transition(AnyTransition.opacity.animation(.easeOut))  //过渡动画
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    date
                }
                ToolbarItem(placement: .topBarTrailing) {
                    settingLink
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if goals.isEmpty {
                    
                } else {
                    plusBtn
                }
            }
            .background {
                if goals.isEmpty {
                    Color(uiColor: .systemGray6).ignoresSafeArea()
                } else {
                    Color(uiColor: .systemGray6).opacity(0.5).ignoresSafeArea()
                }
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
        
        //若添加的目标数量超过3个，就触发该弹窗
        .sheet(isPresented: $showStore, content: {
            PurchaseView()
                .presentationDragIndicator(.visible)
        })
        .onAppear {
            store.loadStoredPurchases()
        }
        

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
    
    private var date: some View {
        HStack(spacing: 4) {
            Text("\(Calendar.current.component(.month, from: Date()))月")
            Text("\(Calendar.current.component(.day, from: Date()))日")
                .fontWeight(.heavy)
        }
        .font(.system(size: 20))
        .foregroundStyle(Color.primary)
    }
    
    private var number: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("总共 \(goals.count)")
            Text("已完成 \(completeGoals.count)")
        }
        .font(.system(size: 12, weight: .bold))
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
            if store.purchased || goals.count < 3 {
                UIImpactFeedbackGenerator.impact(style: .light)
                selectedGoal = GoalModel.empty()
                
            } else {
                UIImpactFeedbackGenerator.impact(style: .light)
                showStore.toggle()
            }
            
        } label: {
            Circle()
                .foregroundStyle(Color.primary)
                .frame(width: 60)
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundStyle(Color("btnTextColor"))
                        .fontWeight(.bold)
                }
                .offset(x: -30, y: -20)
        }
    }
}

#Preview {
    GoalListView()
        .environmentObject(AppSettings())
}
