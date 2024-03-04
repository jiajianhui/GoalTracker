//
//  ToggleView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/3/4.
//

import SwiftUI

struct ToggleView: View {
    
    @State var isCheck:Bool = false
    
    var body: some View {
        Toggle(isOn: $isCheck, label: {
            Text("hello")
        })
        .toggleStyle(MyToggleStyle())
        .padding()
    }
}

struct MyToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    configuration.isOn ? Color.primary : Color("ToggleBgColor")
                )
                .frame(width: 50, height: 30)
                .overlay {
                    Circle()
                        .fill(configuration.isOn ? Color("btnTextColor") : Color("ToggleCircleColor"))
//                        .fill(Color("btnTextColor"))
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                }
                .onTapGesture {
                    UIImpactFeedbackGenerator.impact(style: .light)
                    withAnimation(.spring(duration: 0.3)) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

#Preview {
    ToggleView()
}
