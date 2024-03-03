//
//  GoalTrackerWidget.swift
//  GoalTrackerWidget
//
//  Created by 贾建辉 on 2024/3/2.
//

import WidgetKit
import SwiftUI
import CoreData
import CloudKit

struct Provider: TimelineProvider {
    //从CoreData中获取数据
    private func getData() throws -> [GoalModel] {
        let context = CoreDataManager.shared.viewContext
        
        let request = GoalModel.all()
        let result = try context.fetch(request)
        
        return result
        
    }
    
    
    //占位符样式
    func placeholder(in context: Context) -> SimpleEntry {
        let goals = try? getData()
        
        return SimpleEntry(title: goals?[0].title ?? "", date: Date(), schedule: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        do {
            let goals = try getData()
            let entry = SimpleEntry(title: goals[0].title, date: Date(), schedule: 11)
            completion(entry)
        } catch {
            print(error)
        }
        
        
    }

    
    //数据源
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        
        do {
            let goals = try getData()
            
            //判断是否有数据
            if goals.isEmpty {
                let entry = SimpleEntry(title: "暂无无数据", date: Date(), schedule: 1)
                entries.append(entry)
            } else {
                let emptyEntry = SimpleEntry(
                    title: goals[goals.count - 1].title,
                    date: goals[goals.count - 1].date,
                    schedule: goals[goals.count - 1].schedule)
                entries.append(emptyEntry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch {
            print(error)
        }

       
    }
}

struct SimpleEntry: TimelineEntry {
    let title: String
    let date: Date
    let schedule: Int
}

struct GoalTrackerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            //日期
            HStack(spacing: 2) {
                Text("\(Calendar.current.component(.month, from: Date()))月")
                Text("\(Calendar.current.component(.day, from: Date()))日")
                    .fontWeight(.heavy)
            }
            .font(.system(size: 20))
            .foregroundStyle(Color.primary)
            
            
            //目标内容
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
            }
//            .padding(.vertical)
            .frame(maxHeight: .infinity)
            
            
            //状态
            HStack {
                Group {
                    if Calendar.current.dateComponents([.day], from: entry.date, to: Date()).day ?? 0 == 0 && entry.schedule != 10 {
                        Text("今天创建")
                    } else if Calendar.current.dateComponents([.day], from: entry.date, to: Date()).day ?? 0 != 0 && entry.schedule == 10 {
                        Text("完成啦🎉")
                    } else if Calendar.current.dateComponents([.day], from: entry.date, to: Date()).day ?? 0 == 0 && entry.schedule == 10 {
                        Text("太高效了吧，1天就完成了😎")
                    } else {
                        Text("已过去 \(Calendar.current.dateComponents([.day], from: entry.date, to: Date()).day ?? 0) 天 ")
                    }
                }
                .font(.system(size: 10, weight: .medium, design: .rounded))
                
                Spacer()
                Text(entry.schedule == 10 ? "已完成" : "进行中")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(entry.schedule == 10 ? .green : .purple)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background {
                        entry.schedule == 10 ? Color.green.opacity(0.08) : Color.purple.opacity(0.08)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
}

struct GoalTrackerWidget: Widget {
    let kind: String = "GoalTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                GoalTrackerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                GoalTrackerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    GoalTrackerWidget()
} timeline: {
    SimpleEntry(title: "你好", date: .now, schedule: 1)
    SimpleEntry(title: "2", date: .now, schedule: 22)
}
