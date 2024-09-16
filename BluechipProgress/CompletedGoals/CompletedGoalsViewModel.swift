//
//  CompletedGoalsViewModel.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 12.09.2024.
//

import Foundation


class CompletedGoalsViewModel: ObservableObject {
    
    @Published var completedGoals: [Goal] = []
    
}
