//
//  Goal.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 04.09.2024.
//

import Foundation
import RealmSwift


class Goal:  Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var mainGoalName: String = ""
    @Persisted var imageData: Data?
    @Persisted var deadLine: Date?
    @Persisted var note: String = ""
    
    @Persisted var isCompleted: Bool = false
    @Persisted var isMainGoal: Bool = false
    
    @Persisted var subgoals = RealmSwift.List<Subgoal>()
}


class Subgoal:  Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var name: String = ""
    @Persisted var isCompleted: Bool = false
}
