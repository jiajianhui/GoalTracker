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
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                titleAndDate
                state
            }
            .onTapGesture {
                tapAnimation()
            }
            
            if showDetail {
                VStack(spacing: 19) {
                    LineView()
                    date
                    LineView()
                    gauge
                    LineView()
                    Stepper("更新进度", value: $vm.goal.schedule, in: 0...10, step: 1)
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
    
    //卡片背景
    private var bgStyle: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color("cardBgColor"))
        
            .overlay(alignment: .leading) {
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 16)
                        .fill(vm.goal.schedule == 10 ? .green : .purple)
                        .padding(4)
                        .frame(width: (screenWidth - 72) * (Double(vm.goal.schedule) / 10), height: 12)
                        .opacity(showDetail ? 0 : 1)
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
    
    //目标标题、时间
    private var titleAndDate: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.goal.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(showDetail ? 100 : 1)
            Group {
                if Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0 == 0 && vm.goal.schedule != 10 {
                    Text("今天创建")
                } else if Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0 != 0 && vm.goal.schedule == 10 {
                    Text("完成啦🎉")
                } else if Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0 == 0 && vm.goal.schedule == 10 {
                    Text("太高效了吧，1天就完成了😎")
                } else {
                    Text("已过去 \(Calendar.current.dateComponents([.day], from: vm.goal.date, to: Date()).day ?? 0) 天 ")
                }
            }
            .font(.system(size: 12, weight: .medium, design: .rounded))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.white.opacity(0.0001)
        }
    }
    
    //目标状态
    private var state: some View {
        Text(vm.goal.schedule == 10 ? "已完成" : "进行中")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(vm.goal.schedule == 10 ? .green : .purple)
            .padding(10)
            .background {
                vm.goal.schedule == 10 ? Color.green.opacity(0.08) : Color.purple.opacity(0.08)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    //MARK: - 详情部分
    private var date: some View {
        HStack {
            Text("创建日期")
            Spacer()
            Text(displayDate(vm.goal.date))
        }
    }
    
    private var gauge: some View {
        HStack {
            Text("当前进度")
            Spacer()
            Gauge(
                value: Double(vm.goal.schedule) / 10,  //将schedule转为小数，以供Gauge使用——计算属性
                label: {
                    Text("进度")
                },
                currentValueLabel: {
                    Text("\(vm.goal.schedule * 10)%") //将schedule转为百分比——计算属性
                        .font(.system(size: 16, weight: .medium))
                }
            )
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(vm.goal.schedule == 10 ? .green : .purple )
        }
    }
    
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
        withAnimation(.spring()) {
            showDetail.toggle()
        }
        
        vm.save()
        
        //实现缩放动画
        let tapAnimation = Animation.spring()
        
        withAnimation(tapAnimation){
            scale = 0.93
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(tapAnimation) {
                scale = 1
            }
        }
    }
    
    
}

//#Preview {
//    GoalRowView()
//        .padding()
//}
