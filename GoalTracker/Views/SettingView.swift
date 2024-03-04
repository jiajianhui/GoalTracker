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
    //用户协议开关
    @State private var showAgreement: Bool = false
    
    //更换icon开关
    @State private var showChangeIcon: Bool = false
    
    //iCloud同步开关
    @State private var icloudToggle: Bool = false
    
    //
    @StateObject var notificationManager = NotificationManager()
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    IAP()
                    
                    VStack(spacing: 32) {
                        changeIcon
//                        iCloudSync
                        notificationBtn
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPrivacy) {
                PrivacyAndAgreementView(showPrivacy: true)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showAgreement) {
                PrivacyAndAgreementView()
                    .presentationDragIndicator(.visible)
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
                    .foregroundStyle(Color("cardBgColor"))
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
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String,
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
    
    //通知开关
    private var notificationBtn: some View {
        Toggle(isOn: $notificationManager.isNotificationEnabled, label: {
            HStack {
                Image("通知")
                Text("每日回顾提醒")
                    .fontWeight(.medium)
            }
        })
        .toggleStyle(MyToggleStyle())
        .onChange(of: notificationManager.isNotificationEnabled) { newValue in
            notificationManager.toggleNotification()
        }
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
            showAgreement.toggle()
        } label: {
            SettingRowView(icon: "协议", title: "使用协议", showInfo: false)
        }
    }
    
    
    //版本信息
    var info: some View {
        VStack(spacing: 12) {
            //logo
            Image(systemName: "sparkle")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            
            VStack {
                //具体信息
                HStack(spacing: 4) {
                    //获取app名称
                    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
                        Text("\(appName)")
                    } else {
                        
                    }
                    HStack(spacing: 2) {
                        Text("©")
                            .font(.system(size: 15))
                        Text("2024")
                    }
                    //获取app版本
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text("版本 \(appVersion)")
                    } else {
                        
                    }
                }
                    .font(.system(size: 13, weight: .regular))
                
                Text("Designed by JianHui")
                    .font(.system(size: 11, weight: .regular))
            }
            
        }
        .opacity(0.2)
        .padding(.top, 40)
    }
    
    
}

#Preview {
    SettingView()
        .environmentObject(AppSettings())
}
