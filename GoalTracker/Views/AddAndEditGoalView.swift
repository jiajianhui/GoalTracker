//
//  AddAndEditGoalView.swift
//  GoalTracker
//
//  Created by 贾建辉 on 2024/2/2.
//

import SwiftUI

struct AddAndEditGoalView: View {

    @ObservedObject var vm: AddAndEditViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var showDeleteSheet = false
    
    @State var validAlert = false
    
    var body: some View {
        VStack {
            VStack {
                TextField(PlaceholderOptions.all.randomElement()!, text: $vm.goal.title, axis: .vertical)
                    .fontWeight(.medium)
                LineView()
            }
            .padding(.top, 40)
            
            Spacer()
            
            HStack {
                Button {
                    if !vm.isNew {
                        showDeleteSheet.toggle()
                    } else {
                        dismiss()
                    }
                    
                } label: {
                    Text(vm.isNew ? "取消" : "删除")
                        .foregroundStyle(vm.isNew ? Color.primary : Color.purple)
                        .frame(width: 80, height: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                        }
                }

                Spacer()
                Button {
                    validSave()
                } label: {
                    Text(vm.isNew ? "添加" : "保存")
                        .fontWeight(.bold)
                        .foregroundStyle(Color("btnTextColor"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(vm.isNew ? Color.primary : Color.purple)
                                .opacity(vm.goal.isVaild ? 1 : 0.1)
                        }
                }
                .disabled(vm.goal.isVaild ? false : true)

            }
        }
        .padding()
        .confirmationDialog("", isPresented: $showDeleteSheet) {
            Button("删除", role: .destructive) {
                delete()
            }
            Button("取消", role: .cancel) {
                
            }
        } message: {
            Text("确定要删除吗？此操作无法撤销")
        }

        

    }
    
    private func delete() {
        if !vm.isNew {
            CoreDataManager.shared.delete(vm.goal, in: CoreDataManager.shared.newContext)
        }
        dismiss()
    }
    
    private func validSave() {
        UIImpactFeedbackGenerator.impact(style: .light)
        vm.save()
        dismiss()
    }
}

//#Preview {
//    AddGoalView(vm: AddAndEditViewModel(coreDataManager: CoreDataManager()))
//}
