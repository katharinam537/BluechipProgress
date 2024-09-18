//
//  CompletedCellView.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import SwiftUI

class CompletedGoalsViewModel: ObservableObject {
    
    @Published var completedGoals: [Goal] = []
    
}


struct CompletedCellView: View {
    
    var goal: Goal
    
    var body: some View {
        Rectangle()
            .foregroundColor(.darkBlue)
            .frame(width: getScreenSize().width - 50, height: 200)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.5), radius: 3)
            .glow(.blue.opacity(0.5), radius: 2)
            .overlay {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(goal.mainGoalName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold,design: .serif))
                                    .frame(width: 180, alignment: .leading)
                                    .padding(.top)
                                
                                Spacer()
                            }
                       
                            
                            HStack {
                                Rectangle()
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .overlay {
                                        Text("Done ✅")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 18, weight: .regular, design: .serif))
                                    }
                                
                                Spacer()
                            }
                        }
                      
                        
                        Image("pinkCrown")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.trailing)
                            .padding(.top, 30)
                            .shadow(radius: 10)
                            .glow(.lightPink, radius: 1)
                    }
                    
                        
                    Spacer()
                }
                .padding(.horizontal)
            
            }
    }
}
