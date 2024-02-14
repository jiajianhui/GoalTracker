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
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(vm.goal.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(showDetail ? 100 : 1)
                    Text(displayDate(vm.goal.date))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .opacity(0.6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Color.white.opacity(0.0001)
                }
                
                Text(vm.goal.schedule == 10 ? "已完成" : "进行中")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(vm.goal.schedule == 10 ? .green : .purple)
                    .padding(10)
                    .background {
                        vm.goal.schedule == 10 ? Color.green.opacity(0.08) : Color.purple.opacity(0.08)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            .onTapGesture {
                withAnimation(.easeIn) {
                    vm.save()
                    showDetail.toggle()
                }
            }
            
            if showDetail {
                VStack(spacing: 19) {
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
                    LineView()
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
                    LineView()
                    Stepper("更新任务进度", value: $vm.goal.schedule, in: 0...10, step: 1)
                    LineView()
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
                
            }
        }
        .padding(24)
        .background {
            bgStyle
        }
    }
    
    //时间格式化
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "zh_Hans")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm MM-dd")
        
        return formatter
    }()
    //将Date转换为String
    func displayDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
}


//MARK: - 视图组件
extension GoalRowView {
    
    //MARK: 卡片背景
    private var bgStyle: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.white)
        
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
}

//#Preview {
//    GoalRowView()
//        .padding()
//}
