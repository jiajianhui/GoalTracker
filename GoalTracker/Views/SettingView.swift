//
//  SettingView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/5.
//

import SwiftUI

struct SettingView: View {
    
    @State var sss = false
    
    //分享链接
    private let url = URL(string: "https://apps.apple.com/app/id")!
    
    //隐私政策开关
    @State private var showPrivacy: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    proView
                    proView2
                    
                    VStack(spacing: 32) {
                        changeIcon
                        iCloudSync
                    }
                    .cardStyle()
                    
                    VStack(spacing: 32) {
                        starBtn
                        shareBtn
                        emailFeedBackBtn
                        privacyBtn
                    }
                    .cardStyle()
                    
                    info
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background {
                Color(uiColor: .systemGray6).ignoresSafeArea()
            }
            .navigationTitle("设置")
            .sheet(isPresented: $showPrivacy) {
                Text("privacy")
                    .presentationDetents([.medium, .large])
            }
        }
    }
}


//MARK: - 样式组件
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(20)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.white)
            }
    }
}

//扩展View来创建新函数，方便使用modifier
extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

//MARK: - 函数部分
extension SettingView {
    
    //好评函数
    private func star() {
        if let url = URL(string: "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //邮件反馈函数
    private func emailFeedBack() {
        //获取App名称及版本、iOS版本
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String,
           let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let iOSVersion = UIDevice.current.systemVersion
            
            let subject = "\(appName)-\(appVersion);iOS-\(iOSVersion)" //注意不要有空格，若有，addingPercentEncoding来处理
            
            //发送电子邮件的 URL 格式应该以 mailto: 开头，然后跟着收件人的电子邮件地址。使用 ?subject= 添加主题内容
            let email = "mailto:jia15176168273@icloud.com?subject=\(subject)"
            
            if let emailURL = URL(string: email) {
                UIApplication.shared.open(emailURL)
            }
        }
    }
}

//MARK: - 按钮视图
extension SettingView {
    
    //Pro视图
    private var proView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 6) {
                Text("GoalTracker")
                    .fontWeight(.medium)
                Text("Pro")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(2)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                    }
            }
            VStack(spacing: 10) {
                Text("无限目标，iCloud数据同步")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary)
                    .frame(height: 56)
                    .overlay {
                        Text("立即解锁")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
            }
            Button {
                
            } label: {
                Text("了解详情")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundStyle(Color.primary)
            }
        }
        .cardStyle()
    }
    
    private var proView2: some View {
        VStack(spacing: 20) {
            SettingRowView(icon: "Pro", title: "会员类型", showArrow: false, showInfo: true)
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.primary)
                    .frame(height: 60)
                    .overlay {
                        Text("解锁Pro版")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
            }
        }
        .cardStyle()
    }
    
    //更换图标、iCloud云同步
    private var changeIcon: some View {
        Button {
            
        } label: {
            SettingRowView(icon: "图标", title: "换个图标", info: "默认", showInfo: true)
        }
    }
    
    private var iCloudSync: some View {
        Toggle(isOn: $sss, label: {
            HStack {
                Image("同步")
                Text("iCloud同步")
                    .fontWeight(.medium)
            }
        })
        .tint(.primary)
    }
    
    //好评按钮
    private var starBtn: some View {
        Button {
            star()
        } label: {
            SettingRowView(icon: "好评", title: "给个好评", showInfo: false)
        }
    }
    //分享按钮
    private var shareBtn: some View {
        ShareLink(item: url) {
            SettingRowView(icon: "分享", title: "分享给朋友", showInfo: false)
        }
    }
    //反馈按钮
    private var emailFeedBackBtn: some View {
        Button {
            emailFeedBack()
        } label: {
            SettingRowView(icon: "反馈", title: "意见反馈", showInfo: false)
        }
    }
    //展示隐私政策按钮
    private var privacyBtn: some View {
        Button {
            showPrivacy.toggle()
        } label: {
            SettingRowView(icon: "隐私", title: "隐私政策", showInfo: false)
        }
    }
    
    //版本信息
    var info: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkle")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            VStack(spacing: 2) {
                Text("版本 1.0 ")
                    .font(.system(size: 14, weight: .regular))
                Text("Design by JianHui")
                    .font(.system(size: 14, weight: .regular))
            }
            
        }
        .padding(.top, 40)
        .opacity(0.2)
    }
    
    
}

#Preview {
    SettingView()
}
