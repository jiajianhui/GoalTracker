//
//  FilterView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/25.
//

import SwiftUI


struct FilterView: View {
    //从数据库拿数据
    var goals: FetchedResults<GoalModel>
    
    let filterName: [String] = [
        NSLocalizedString("全部", comment: "Comment 1"),
        NSLocalizedString("进行中", comment: "Comment 2"),
        NSLocalizedString("已完成", comment: "Comment 3")
    ]
    
    //筛选配置项
    @Binding var num: Int 
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(filterName.indices, id: \.self) { i in
                Button {
                    UIImpactFeedbackGenerator.impact(style: .soft)
                    
                    num = i
                } label: {
                    Text(filterName[i])
                        .selectedTabStyle(isSelected: num == i)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: num) { newValue in
            switch newValue {
            case 0:
                goals.nsPredicate = GoalModel.filter(with: FilterConfig.init(filter: .all))
            case 1:
                goals.nsPredicate = GoalModel.filter(with: FilterConfig.init(filter: .unfinish))
            case 2:
                goals.nsPredicate = GoalModel.filter(with: FilterConfig.init(filter: .complete))
                
            default:
                break
            }
        }
        
    }
}

//选中及未选中样式
struct SelectedTabModifier: ViewModifier {
    
    var isSelected: Bool = false
    
    func body(content: Content) -> some View {
        if isSelected {
            content
                .foregroundStyle(Color("btnTextColor"))
                .font(.system(size: 15, weight: .medium))
                .padding(8)
                .padding(.horizontal, 10)
                .background {
                    Color.primary.clipShape(RoundedRectangle(cornerRadius: 100))
                }
            
        } else {
            content
                .foregroundStyle(Color.primary).opacity(0.4)
                .font(.system(size: 15, weight: .medium))
                .padding(10)
                .padding(.horizontal, 8)
                .background {
                    Color(uiColor: .systemGray5).opacity(0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
        }
    }
}

extension View {
    func selectedTabStyle(isSelected: Bool) -> some View {
        modifier(SelectedTabModifier(isSelected: isSelected))
    }
}





//#Preview {
//    FilterView(goals: FetchedResults<GoalModel.all>)
//}
