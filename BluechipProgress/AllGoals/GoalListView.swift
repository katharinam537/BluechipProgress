//
//  GoalListView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 11.09.2024.
//

import SwiftUI


struct GoalListView: View {
    
    @State var isNewGoalShown = false
    @StateObject var vm = GoalListViewModel()
    var completion: () -> ()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack {
                    HStack {
                        Text("ALL GOALS")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            isNewGoalShown.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(vm.goalList, id: \.id) { goal in
                            NavigationLink {
                                GoalDetailView(goal: goal) {
                                    vm.goalList = []
                                    
                                    withAnimation(.default) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            if let list = StorageManager.shared.getIncompleteGoals() {
                                                vm.goalList = Array(list)
                                            }
                                        }
                                    }
                                } onClosing: {
                                    completion()
                                }
                                .onAppear {
                                    DispatchQueue.main.async {
                                        completion()

                                    }
                                }
                                .navigationBarBackButtonHidden()
                            } label: {
                                GoalSmallCellView(goal: goal)
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                if let list = StorageManager.shared.getIncompleteGoals() {
                    vm.goalList = Array(list)
                }
        }
        }
        .tint(.white)
        .fullScreenCover(isPresented: $isNewGoalShown) {
            NewGoalView()
                .onDisappear {
                    vm.goalList = []
                    
                    withAnimation(.default) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let list = StorageManager.shared.getIncompleteGoals() {
                                vm.goalList = Array(list)
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    GoalListView(){}
}
