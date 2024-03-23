//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

struct GoalRowView: View {
    
    @ObservedObject var vm: AddAndEditViewModel
    
    //是否展示细节
    @State var showDetail = false
    
    var screenWidth = UIScreen.main.bounds.width
    
    @State var currentColor: Color = .purple
    
    //当前选择的Goal
    @Binding var selectedGoal: GoalModel?
    
    //点击时的缩放变量
    @State private var scale: CGFloat = 1
    
    //picker
    let pickerOptions: [String] = [
        NSLocalizedString("百分比", comment: "picker"),
        NSLocalizedString("数字", comment: "picker")
    ]
    
    private let height: CGFloat = 36
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                titleAndDate
                if showDetail {
                    circleState
                } else {
                    textState
                }
            }
            .onTapGesture {
                tapAnimation()
            }
            
            if showDetail {
                VStack(spacing: 19) {
                    LineView()
                    units
                    LineView()
                    setGoalValue
                    LineView()
                    currentState
                    LineView()
                    updateSchedule
                    LineView()
                    btns
                }
            }
        }
        .padding(24)
        .background {
            bgStyle
        }
        .scaleEffect(scale)
    }
    
    //时间格式化
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "zh_Hans")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        
        return formatter
    }()
    //将Date转换为String
    func displayDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
}


//MARK: - 视图组件
extension GoalRowView {
    
    //卡片背景、进度条
    private var bgStyle: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color("cardBgColor"))
        
            .overlay(alignment: .leading) {
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        //灰色条
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.primary.opacity(0.06))
                            .padding(4)
                            .frame(height: 12)
                            .opacity(showDetail ? 0 : 1)
                        //进度条
                        if vm.goal.pickerValue == 0 {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(vm.goal.schedule == 100 ? .green : .purple)
                                .padding(4)
                                .frame(
                                    width: (screenWidth - 72) * (Double(vm.goal.schedule) / 100),
                                    height: 12
                                )
                                .opacity(showDetail ? 0 : 1)
                            
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(vm.goal.currentScheduleNum == vm.goal.scheduleNum ? .green : .purple)
                                .padding(4)
                                .frame(
                                    width: vm.goal.scheduleNum != 0 ? (screenWidth - 72) * (Double(vm.goal.currentScheduleNum) / Double(vm.goal.scheduleNum)) : screenWidth - 72,
                                    height: 12
                                )
                                .opacity(showDetail ? 0 : 1)
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 6)
                    
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(uiColor: .systemGray5).opacity(0.6), lineWidth: 1)
            }
    }
    
    //颜色主题
    private var colorTheme: some View {
        VStack {
            LineView()
            HStack {
                Text("任务主题")
                Spacer()
                HStack {
                    ForEach(ColorOptions.all.indices, id: \.self) { index in
                        Button {
                            currentColor = ColorOptions.all[index]
                        } label: {
                            Circle()
                                .fill(ColorOptions.all[index])
                                .frame(width: 24)
                        }
                    }
                }
            }
        }
    }
    
    //目标标题、提示文案
    private var titleAndDate: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.goal.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(showDetail ? 100 : 1)
            
            if vm.goal.pickerValue == 0 {
                Group {
                    if Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.schedule != 10 {  //检查两个日期是否是同一天
                        Text("今天创建")
                    } else if !Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.schedule == 100 {
                        Text("完成啦🎉")
                    } else if Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.schedule == 100 {
                        Text("太高效了吧，1天就完成了😎")
                    } else {
                        //计算目标时间与当前日期之间的天数差异（使用了 [.day] 作为第一个参数，表示只关心日期差异的天数），from 参数表示起始日期，而 to 参数表示结束日期。
                        if (Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0) == 0 {
                            Text("快过去1天啦")
                        } else {
                            Text("已过去 \(Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0) 天 ")
                        }
                        
                    }
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
            } else {
                Group {
                    if Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.currentScheduleNum != vm.goal.scheduleNum {  //检查两个日期是否是同一天
                        Text("今天创建")
                    } else if !Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.currentScheduleNum == vm.goal.scheduleNum {
                        Text("完成啦🎉")
                    } else if Calendar.current.isDate(vm.goal.date, inSameDayAs: Date()) && vm.goal.currentScheduleNum == vm.goal.scheduleNum {
                        Text("太高效了吧，1天就完成了😎")
                    } else {
                        //计算目标时间与当前日期之间的天数差异（使用了 [.day] 作为第一个参数，表示只关心日期差异的天数），from 参数表示起始日期，而 to 参数表示结束日期。
                        if (Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0) == 0 {
                            Text("快过去1天啦")
                        } else {
                            Text("已过去 \(Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0) 天 ")
                        }
                        
                    }
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.white.opacity(0.0001)
        }
    }
    
    //目标状态
    private var textState: some View {
        if vm.goal.pickerValue == 0 {
            Text(vm.goal.schedule == 100 ? "已完成" : "进行中")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(vm.goal.schedule == 100 ? .green : .purple)
                .padding(10)
                .background {
                    vm.goal.schedule == 100 ? Color.green.opacity(0.08) : Color.purple.opacity(0.08)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Text(vm.goal.currentScheduleNum == vm.goal.scheduleNum ? "已完成" : "进行中")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(vm.goal.currentScheduleNum == vm.goal.scheduleNum ? .green : .purple)
                .padding(10)
                .background {
                    vm.goal.currentScheduleNum == vm.goal.scheduleNum ? Color.green.opacity(0.08) : Color.purple.opacity(0.08)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
    
    //圆环指示条
    private var circleState: some View {
        ZStack {
            Circle()
                .stroke(.primary.opacity(0.06), lineWidth: 5)
            if vm.goal.pickerValue == 0 {
                Circle()
                    // CGFloat(num / 10) 与 CGFloat(num) / 10不一样，前者小数部分可能会丢失，后者不会
                    .trim(from: 0.0, to: CGFloat(vm.goal.schedule) / 100)
                    .stroke(vm.goal.schedule == 100 ? .green : .purple, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring, value: vm.goal.schedule)
            } else {
                Circle()
                    .trim(from: 0.0, to: CGFloat(vm.goal.currentScheduleNum) / CGFloat(vm.goal.scheduleNum))
                    .stroke(vm.goal.currentScheduleNum == vm.goal.scheduleNum ? .green : .purple, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring, value: vm.goal.currentScheduleNum)
            }
            
        }
        .frame(width: 26)
        
    }
    
    //MARK: - 详情部分
    private var date: some View {
        HStack {
            Text("创建日期")
            Spacer()
            Text(displayDate(vm.goal.date))
        }
    }
    
    //目标单位
    private var units: some View {
        HStack {
            Text("目标单位")
            Spacer()
            Picker("1", selection: $vm.goal.pickerValue) {
                ForEach(pickerOptions.indices, id: \.self) { index in
                    Text(pickerOptions[index])
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 140)
        }
        .frame(height: height)
    }
    
    
    //设置目标
    private var setGoalValue: some View {
        HStack {
            Text("设置目标")
            Spacer()
            if vm.goal.pickerValue == 0 {
                Text("100%")
                    .opacity(0.5)
                
            } else {
                Picker("picker", selection: $vm.goal.scheduleNum) {
                    ForEach(0..<200) { index in
                        Text("\(index)")
                    }
                }
            }
        }
        .frame(height: height)
        
    }
    
    //当前进度
    private var currentState: some View {
        HStack {
            Text("当前进度")
            Spacer()
            
            if vm.goal.pickerValue == 0 {
                Text("\(vm.goal.schedule)%")
            } else {
                VStack {
                    Text("\(vm.goal.currentScheduleNum)")
                }
                .padding(.trailing, 16)
                .onChange(of: vm.goal.scheduleNum) { newValue in
                    if newValue <= vm.goal.currentScheduleNum {
                        vm.goal.currentScheduleNum = newValue
                        vm.save()
                    }
                }
            }
            
        }
        .frame(height: height)
    }
    
    //更新进度
    private var updateSchedule: some View {
        HStack {
            if vm.goal.pickerValue == 0 {
                Stepper("更新进度", value: $vm.goal.schedule, in: 0...100, step: 1)
            } else {
                Stepper("更新进度", value: $vm.goal.currentScheduleNum, in: 0...vm.goal.scheduleNum, step: 1)
                    .onChange(of: vm.goal.currentScheduleNum) { newValue in
                        vm.goal.currentScheduleNum = newValue
                    }
            }
        }
        .frame(height: height)
    }
    
    //按钮组
    private var btns: some View {
        HStack {
            
            Button {
                withAnimation(.easeOut) {
                    selectedGoal = vm.goal
                    showDetail.toggle()
                }
            } label: {
                Text("编辑")
                    .foregroundStyle(Color.purple)
                    .frame(width: 80, height: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                    }
            }

            Spacer()
            
            Button {
                withAnimation(.easeOut) {
                    vm.save()
                    showDetail.toggle()
                }
            } label: {
                Text("保存")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.purple)
                    }
            }

        }
        .padding(.top, 8)
    }
    
    
    //MARK: - 点击缩放动画
    private func tapAnimation() {
        UIImpactFeedbackGenerator.impact(style: .light)
        withAnimation(.spring(duration: 0.5)) {
            showDetail.toggle()
        }
        
        vm.save()
        
        //实现缩放动画
        let tapAnimation = Animation.spring()
        
        withAnimation(tapAnimation){
            scale = 0.93
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(tapAnimation) {
                scale = 1
            }
        }
    }
    
    
}

//#Preview {
//    GoalRowView(vm: AddAndEditViewModel(coreDataManager: CoreDataManager(), goal: nil), selectedGoal: .constant(nil))
//        .padding()
//}
