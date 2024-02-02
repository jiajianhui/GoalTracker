//
//  LineView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

struct LineView: View {
    var body: some View {
        Rectangle()
            .fill(Color(uiColor: .systemGray5).opacity(0.6))
            .frame(height: 1)
    }
}

#Preview {
    LineView()
}
