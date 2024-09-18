//
//  GoalListViewModel.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import Foundation

class GoalListViewModel: ObservableObject {
    
    @Published var goalList: [Goal] = []
    
}
