//
//  Haptic.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import Foundation
import SwiftUI

extension UIImpactFeedbackGenerator {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
