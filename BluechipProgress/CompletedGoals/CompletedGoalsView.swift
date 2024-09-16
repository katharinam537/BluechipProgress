//
//  CompletedGoalsView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 12.09.2024.
//

import SwiftUI

struct CompletedGoalsView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = CompletedGoalsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("COMPLETED GOALS")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                    
                if !vm.completedGoals.isEmpty {
                    ScrollView {
                        ForEach(vm.completedGoals, id: \.id) { goal in
                            CompletedCellView(goal: goal)
                                .padding()
                        }
                        .padding(.bottom, 150)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    VStack {
                        Text("You don't have any Completed Goals yet. \nDon't be upset, you can do it!")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 32, weight: .ultraLight))
                            .padding()
                            .padding(.top, 50)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "trophy")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 132, weight: .ultraLight))
                            .padding(.top, 50)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
            }
        }
        .onAppear {
            if let list = StorageManager.shared.getCompletedGoals() {
                vm.completedGoals = Array(list)
            }
        }
    }
}

#Preview {
    CompletedGoalsView()
}
