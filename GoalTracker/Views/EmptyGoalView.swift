//
//  EmptyGoalView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/20.
//

import SwiftUI

struct EmptyGoalView: View {
    
    @Binding var goalModel: GoalModel?
    
    //动画变量
    @State var isAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            imageView
            VStack(spacing: 30) {
                textView
                btnView
            }
        }
        .frame(maxWidth: .infinity)
        //执行动画
        .onAppear {
            addAnimation()
        }
    }
    
    
    
}

extension EmptyGoalView {
    //动画函数
    private func addAnimation() {
        //如果动画已经执行就return，只调用动画一次
        guard !isAnimation else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //动画详情
            withAnimation (
                Animation
                    .easeInOut(duration: 2)
                    .repeatForever()
            ) {
                isAnimation.toggle()
            }
        }
    }
    
    //图片
    private var imageView: some View {
        Image("empty")
            .shadow(color: .primary.opacity(0.05), radius: isAnimation ? 10 : 5, y: isAnimation ? 20 : 10)
            .offset(y: isAnimation ? -8 : 0)
    }
    
    //文案
    private var textView: some View {
        VStack(spacing: 10) {
            Text("立即开始")
                .font(.system(size: 20, weight: .bold, design: .default))
            Text("创建你的目标或任务，持续关注和追踪它们，保持创造，提高动力。")
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .lineSpacing(2)
                .opacity(0.4)
                .padding(.horizontal, 60)
        }
    }
    
    //按钮
    private var btnView: some View {
        Button {
            UIImpactFeedbackGenerator.impact(style: .light)
            goalModel = GoalModel.empty()
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 280, height: 64)
                .overlay {
                    Text("添加")
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                }
        }
    }
}

#Preview {
    EmptyGoalView(goalModel: .constant(nil))
}
