//
//  StorageManager.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 10.09.2024.
//

import Foundation
import RealmSwift


class StorageManager {
    
    
    static let shared = StorageManager()
    
    private init(){}
    
    let realm = try! Realm()
    
    @ObservedResults(Goal.self) var goals
    
    
    func saveGoal(goal: Goal) {
        $goals.append(goal)
    }
    
    func fetchFirstMainGoal() -> Goal? {
        let mainGoal = realm.objects(Goal.self).filter("isMainGoal == true").first
        return mainGoal
    }
    
    func resetAllMainGoals() {
        do {
            
            let mainGoals = realm.objects(Goal.self).filter("isMainGoal == true")
            
            try realm.write {
                mainGoals.setValue(false, forKey: "isMainGoal")
            }
        } catch {
            print("Error updating Realm database: \(error)")
        }
    }
    
    func markFirstIncompleteSubgoalAsComplete(for goal: Goal) {
        do {
            
            // Находим цель в базе данных
            if let goalInDB = realm.object(ofType: Goal.self, forPrimaryKey: goal.id) {
                
                // Ищем первый subgoal, который не завершён
                if let incompleteSubgoal = goalInDB.subgoals.first(where: { !$0.isCompleted }) {
                    
                    // Обновляем его в транзакции
                    try realm.write {
                        incompleteSubgoal.isCompleted = true
                    }
                    
                    print("Subgoal updated successfully")
                } else {
                    print("No incomplete subgoals found")
                }
            } else {
                print("Goal not found in database")
            }
        } catch {
            print("Error accessing Realm database: \(error)")
        }
    }
    
    func getSubgoals(for goal: Goal) -> List<Subgoal>? {
        if let goalInDB = realm.object(ofType: Goal.self, forPrimaryKey: goal.id) {
            return goalInDB.subgoals
        } else {
            print("Goal not found in database")
            return nil
        }
    }
    
    func updateGoalStatus(for goal: Goal) {
        do {
            
            if let goalInDB = realm.object(ofType: Goal.self, forPrimaryKey: goal.id) {
                try realm.write {
                    // Обновляем статус цели
                    goalInDB.isCompleted = true
                    goalInDB.isMainGoal = false
                }
            } else {
                print("Goal not found in database")
            }
        } catch {
            print("Error accessing Realm database: \(error)")
        }
    }
    
    func getIncompleteGoals() -> Results<Goal>? {
        // Получаем все цели, у которых isCompleted == false
        let incompleteGoals = realm.objects(Goal.self).filter("isCompleted == false")
        
        return incompleteGoals
    }
    
    func getCompletedGoals() -> Results<Goal>? {
        // Получаем все цели, у которых isCompleted == true
        let completedGoals = realm.objects(Goal.self).filter("isCompleted == true")
        
        return completedGoals
    }
    
    func markGoalAsComplete(goal: Goal) {
        do {
            // Находим цель в базе данных
            if let goalInDB = realm.object(ofType: Goal.self, forPrimaryKey: goal.id) {
                try realm.write {
                    // Обновляем статус isCompleted на true
                    goalInDB.isCompleted = true
                }
                print("Goal marked as complete")
            } else {
                print("Goal not found in database")
            }
        } catch {
            print("Error accessing Realm database: \(error)")
        }
    }
    
    func markSubgoalAsComplete(subgoal: Subgoal) {
        do {            
            // Находим subgoal в базе данных
            if let subgoalInDB = realm.object(ofType: Subgoal.self, forPrimaryKey: subgoal.id) {
                try realm.write {
                    // Обновляем статус isCompleted на true
                    subgoalInDB.isCompleted = true
                }
                print("Subgoal marked as complete")
            } else {
                print("Subgoal not found in database")
            }
        } catch {
            print("Error accessing Realm database: \(error)")
        }
    }
    
    func deleteAllObjects() {
        do {
            try realm.write {
                let objectTypes = [Goal.self, Subgoal.self]
                
                for objectType in objectTypes {
                    let objects = realm.objects(objectType)
                    realm.delete(objects)
                }
            }
        } catch {
            print("Ошибка при удалении объектов из Realm: \(error.localizedDescription)")
        }
    }
}

