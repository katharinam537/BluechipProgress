//
//  GoalSmallCellView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 11.09.2024.
//

import SwiftUI

class GoalSmallCellViewModel: ObservableObject {
    @Published var subgoals: [Subgoal] = []
    @Published var nextSub = ""
    @Published var counter = 1
}

struct GoalSmallCellView: View {
    
    var goal: Goal
    
    @StateObject var vm = GoalSmallCellViewModel()
        
    var body: some View {
        Rectangle()
            .foregroundColor(.darkBlue)
            .frame(width: getScreenSize().width - 50, height: 200)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.5), radius: 3)
            .glow(.blue.opacity(0.5), radius: 2)
            .overlay {
                VStack {
                    Text(goal.mainGoalName)
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: getScreenSize().width - 80, alignment: .leading)
                        .padding(.top, 20)
                    
                    if let date = goal.deadLine {
                        Text("Deadline: \(formattedDateString(from: date))")
                            .frame(width: getScreenSize().width - 80, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .thin))
                    }
                    
                    if !vm.subgoals.isEmpty {
                        SubgoalsView(subgoals: vm.subgoals, counter: $vm.counter)
                    }
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 70, height: 45)
                                .cornerRadius(12)
                            
                            Text("Open")
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.leading)
                    
                    Spacer()
                }
            }
            .onChange(of: goal.subgoals) { sub in
                vm.subgoals = []
                vm.subgoals = Array(sub)
                vm.nextSub = getNextSubgoals()
            }
            .onAppear {
                vm.subgoals = Array(goal.subgoals)
                vm.nextSub = getNextSubgoals()
            }
    }
    
    func getNextSubgoals() -> String {
        var name = ""
        
        name = vm.subgoals.first { sub in
            sub.isCompleted == false
        }?.name ?? ""
        
        if name.isEmpty {
            name = "\nAll subgoals are done"
        }
        
        return name
    }
    
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
//
//#Preview {
//    GoalSmallCellView(){}
//}
