//
//  TasksSreenModel.swift
//  StudyList
//
//  Created by Александр on 8/28/23.
//

import CoreData
import UIKit

class TasksScreenManager {
    var model: [TasksModel] = []
    private(set) var filteredTasks: [TasksModel] = []
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    func fetchTasksOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksModel")
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [TasksModel]
            model = fetchedScheduleOptions ?? []
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTasks(indexPath: IndexPath) {
        let tasksToDelete = filteredTasks[indexPath.row]
        
        context.delete(tasksToDelete)
        
        do {
            try context.save()
            filteredTasks.remove(at: indexPath.row)
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }
    
    func getModel(indexPath: IndexPath) -> TasksModel? {
        if indexPath.row >= 0 && indexPath.row < filteredTasks.count {
            return filteredTasks[indexPath.row]
        } else {
            print("Ошибка: Index out of range")
            return nil // Возвращаем nil вместо значения по умолчанию
        }
    }
    
    func updateFilteredTasks(_ schedules: [TasksModel]) {
        print(schedules.count)
        filteredTasks = schedules
    }
    
    func countModel() -> Int{
        return filteredTasks.count
    }
}

struct TasksScreenModel {
    var context: NSManagedObjectContext!
    var task: TasksModel
}
