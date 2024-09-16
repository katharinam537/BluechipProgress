//
//  GoalListViewModel.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 11.09.2024.
//

import Foundation


class GoalListViewModel: ObservableObject {
    
    @Published var goalList: [Goal] = []
    
}
