//
//  PrivacyView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/19.
//

import SwiftUI

struct PrivacyAndAgreementView: View {
    
    var showPrivacy: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if showPrivacy {
                    VStack(alignment: .leading, spacing: 36) {
                        //获取app名称
                        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
                            Text("\(appName) 尊重并保护所有使用服务用户的个人隐私和数据隐私。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本软件不会将这些信息对外披露或向第三方提供。本软件会不时更新本隐私权政策。您在同意本软件服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本软件服务使用协议不可分割的一部分。")
                                .lineSpacing(6)
                        } else {
                            
                        }
                        PrivacyRowView(title: NSLocalizedString("1. 数据使用范围", comment: "0"), content: NSLocalizedString("所有数据仅供用户自己查看，应用不会分享用户产品数据给任何第三方机构。", comment: "0"))
                        PrivacyRowView(title: NSLocalizedString("2. 信息披露", comment: "0"), content: NSLocalizedString("本软件不会将您的信息披露给任何第三方机构。", comment: "0"))
                        PrivacyRowView(title: NSLocalizedString("3. 信息存储", comment: "0"), content: NSLocalizedString("本软件收集的有关您的信息和资料将保存在您的设备本地和iCloud中", comment: "0"))
                        PrivacyRowView(title: NSLocalizedString("4. 使用条款的变更", comment: "0"), content: NSLocalizedString("当有新的使用条款跟新的时候，我们会在这个页面更新内容，这些条款更新之后会立即生效。", comment: "0"))
                        PrivacyRowView(title: NSLocalizedString("5. 联系我们", comment: "0"), content: NSLocalizedString("如果您对产品及隐私政策有任何疑问或建议，请随时通过设置页的意见反馈联系到我。", comment: "0"))
                        
                    }
                } else {
                    VStack(alignment: .leading, spacing: 36) {
                        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
                            Text("在购买 Pro 之前，你可以阅读 App的使用协议来确定更多的信息。")
                            
                            PrivacyRowView(title: NSLocalizedString("1. App 功能", comment: "0"), content: NSLocalizedString("GoalCraft 是一款关注和管理个人目标或任务的工具，可以在 iPhone，iPad 和 Mac 上下载使用。", comment: "0"))
                            PrivacyRowView(title: NSLocalizedString("2. 免费版本", comment: "0"), content: NSLocalizedString("GoalCraft 免费版本最多可添加3个目标或任务，如果你需要添加更多目标和任务，可以订阅Pro版本，全平台一次性付费，可在多个平台里恢复购买使用。", comment: "0"))
                            PrivacyRowView(title: NSLocalizedString("3. 订阅 Pro", comment: "0"), content: NSLocalizedString("具体订阅可以参考付费页面，付费采取一次性付费机制，一次付费免费使用所有功能，永远免费升级。", comment: "0"))
                            PrivacyRowView(title: NSLocalizedString("4. 使用条款的变更", comment: "0"), content: NSLocalizedString("当有新的使用条款跟新的时候，我们会在这个页面更新内容，这些条款更新之后会立即生效。", comment: "0"))
                            PrivacyRowView(title: NSLocalizedString("5. 联系我们", comment: "0"), content: NSLocalizedString("如果您对产品及隐私政策有任何疑问或建议，请随时通过设置页的意见反馈联系到我。", comment: "0"))
                        } else {
                            
                        }
                    }
                }
                
                
            }
            .padding(.horizontal)
            .navigationTitle(showPrivacy ? "隐私政策" : "使用协议")
        }
    }
}

struct PrivacyRowView: View {
    
    var title: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
            Text(content)
                .lineSpacing(6)
        }
    }
}

#Preview {
    PrivacyAndAgreementView()
}
