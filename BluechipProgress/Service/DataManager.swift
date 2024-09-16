//
//  DataManager.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 04.09.2024.
//

import SwiftUI


class DataManager {
    static let shared = DataManager()
    
    private init(){}
    
    func getMOCK() -> Goal {
        let mainGoal = Goal()
        mainGoal.mainGoalName = "Do something Cool"
        mainGoal.deadLine = Date()
        mainGoal.note = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        
        let subgoal = Subgoal()
        subgoal.name = "1 subgoal"
        subgoal.isCompleted = true
        
        mainGoal.subgoals.append(subgoal)
        
        if let image = UIImage(named: "pinkCrown") {
            mainGoal.imageData = image.jpegData(compressionQuality: 1)
        }
       
        
        for i in 2...10 {
            let subgoal = Subgoal()
            subgoal.name = "\(i) subgoal"
            
            mainGoal.subgoals.append(subgoal)
        }
        
        return mainGoal
    }
}
