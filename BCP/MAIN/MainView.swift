//
//  MainView.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//


import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var mainGoal: Goal?
    
    
}


struct MainView: View {
    
    @State var isOndoarding = false
    @State var isNewGoalShown = false
    @State var isCompletedGoalsShown = false
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack {
                    HStack {
                        Text("BLUECHIP PROGRESS")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            
                        
                        Spacer()
                        
                        
                    }
                    .padding(.top)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    
                    if let goal = vm.mainGoal {
                        Text("Main Goal:")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .padding(.top)
                            .frame(width: getScreenSize().width - 40, alignment: .leading)
                        
                        GoalCardView(goal: goal) {
                            vm.mainGoal = nil
                        }
                    } else {
                        VStack {
                            Text("You don't have Main Goal yet. \nIt's time to set your first one!")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.5))
                                .font(.system(size: 24, weight: .ultraLight))
                                .padding(.horizontal)
                                .padding(.top, 40)
                            
                            Image(systemName: "trophy")
                                .foregroundStyle(.white.opacity(0.5))
                                .font(.system(size: 50, weight: .ultraLight))
                                .padding(.top, 20)
                        }
                    }
                    
                          
                    Spacer()
                    
                    Button {
                        isNewGoalShown.toggle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(height: 70)
                                .cornerRadius(24)
                                .foregroundColor(.white)
                            
                            Text("Set new Goal")
                                .font(.system(size: 22, weight: .regular, design: .serif))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    
                    
                }
            }

        }
        .fullScreenCover(isPresented: $isOndoarding) {
            OnboardingView()
        }
        .fullScreenCover(isPresented: $isNewGoalShown) {
            NewGoalView()
                .onDisappear {
                    vm.mainGoal = StorageManager.shared.fetchFirstMainGoal()
                }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
                UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
                isOndoarding = true
            }
            
            vm.mainGoal = StorageManager.shared.fetchFirstMainGoal()
        }
    }
}
