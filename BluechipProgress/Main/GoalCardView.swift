//
//  GoalCardView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 05.09.2024.
//

import SwiftUI

class GoalCardViewModel: ObservableObject {
    @Published var subgoals: [Subgoal] = []
    @Published var nextSub = ""
    @Published var counter = 1
}

struct GoalCardView: View {
    
    var goal: Goal
    var completion: () -> ()
    
    @StateObject var vm = GoalCardViewModel()
        
    var body: some View {
        Rectangle()
            .foregroundColor(.darkBlue)
            .frame(width: getScreenSize().width - 50, height: getScreenSize().height / 2.5)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.5), radius: 3)
            .glow(.blue.opacity(0.5), radius: 2)
            .overlay {
                VStack {
                    Text(goal.mainGoalName)
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .frame(width: getScreenSize().width - 80, alignment: .leading)
                        .padding(.top, 50)
                    
                    if let date = goal.deadLine {
                        Text("Deadline: \(formattedDateString(from: date))")
                            .frame(width: getScreenSize().width - 80, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .thin, design: .serif))
                    }
                    
                    
                    
                    if !vm.subgoals.isEmpty {
                        
                        SubgoalsView(subgoals: vm.subgoals, counter: $vm.counter)
                            
                        Text("Next Subgoal: \(vm.nextSub)")
                            .frame(width: getScreenSize().width - 80, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .thin))
                            .padding(.top, 25)
                    }
                    
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        
                        Button {
                            withAnimation {
                                StorageManager.shared.markFirstIncompleteSubgoalAsComplete(for: goal)
                                if let subgoals = StorageManager.shared.getSubgoals(for: goal) {
                                    vm.subgoals = Array(subgoals)
                                    vm.counter += 1
                                }
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 60)
                                    .cornerRadius(12)
                                
                                Text("Move \nForward")
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                    .foregroundStyle(.black)
                            }
                        }
                        
                        Button {
                            StorageManager.shared.updateGoalStatus(for: goal)
                            completion()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 60)
                                    .cornerRadius(12)
                                
                                Text("Complete \nGoal")
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    
                }
            }
            .rotatable()
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
}

//#Preview {
//    GoalCardView()
//}
