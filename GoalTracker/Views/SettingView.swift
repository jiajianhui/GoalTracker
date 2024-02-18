//
//  SettingView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/5.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    
    //分享链接
    private let url = URL(string: "https://apps.apple.com/app/id6477860453")!
    
    //隐私政策开关
    @State private var showPrivacy: Bool = false
    
    //更换icon开关
    @State private var showChangeIcon: Bool = false
    
    //iCloud同步开关
    @State private var icloudToggle: Bool = false
    
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    IAP()
                    
                    VStack(spacing: 32) {
                        changeIcon
                        iCloudSync
                    }
                    .cardStyle()
                    
                    VStack(spacing: 32) {
                        starBtn
                        shareBtn
                        emailFeedBackBtn
                    }
                    .cardStyle()
                    
                    VStack(spacing: 32) {
                        privacyBtn
                        useProtocolBtn
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
                privacyView
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showChangeIcon) {
                ChangeIconView()
                    .presentationDragIndicator(.visible)
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
        if let url = URL(string: "https://itunes.apple.com/app/id6477860453?action=write-review") {
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
    
    
    //更换图标
    private var changeIcon: some View {
        Button {
            showChangeIcon.toggle()
        } label: {
            //动态切换info
            SettingRowView(icon: "图标", title: "换个图标", info: "\(iconTitle[appSettings.appIconSettings])", showInfo: true)
        }
    }
    
    //iCloud云同步
    private var iCloudSync: some View {
        Toggle(isOn: $icloudToggle, label: {
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
    
    //展示用户协议
    private var useProtocolBtn: some View {
        Button {
            showPrivacy.toggle()
        } label: {
            SettingRowView(icon: "协议", title: "使用协议", showInfo: false)
        }
    }
    
    //隐私政策
    private var privacyView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("🙅")
                        .font(.system(size: 46))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("隐私大于一切！！！")
                    Text("我非常在意您的隐私，绝对不会上传您的任何数据，所有数据均在设备端离线运行。")
                }
                .lineSpacing(3)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                    
            }
            .navigationTitle("隐私政策")
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
        .environmentObject(AppSettings())
}
