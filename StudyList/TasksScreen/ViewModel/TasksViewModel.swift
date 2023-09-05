//
//  TasksViewModel.swift
//  StudyList
//
//  Created by Александр on 8/27/23.
//

import FSCalendar
import UIKit
import CoreData

class TasksViewModel {
    private let model: TasksScreenManager
    
    // Обработчик задач
    var onTasksUpdated: (() -> Void)?
    
    init(model: TasksScreenManager) {
        self.model = model
    }
    
    // MARK: - External methods
    
    func fetchTasksOptions() {
        model.fetchTasksOptions()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        model.deleteTasks(indexPath: indexPath)
    }
    
    // Обновить его, чтобы вместо этого использовать замыкание
    func tasksOnDay(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }
        
        let filtered = model.model.filter { model in
            if model.weekDay == weekday {
                return true
            }
            
            if let scheduleDate = model.dateNumbers {
                return Calendar.current.isDate(date, inSameDayAs: scheduleDate)
            }
            
            return false
        }
        model.updateFilteredTasks(filtered)
        onTasksUpdated?()
    }
    
    func numberOfTasks() -> Int {
        return model.countModel()
    }
    
    func taskItem(at indexPath: IndexPath) -> TasksScreenModel? {
        if let taskModel = model.getModel(indexPath: indexPath) {
            let taskItem = TasksScreenModel(context: model.managedObjectContext, task: taskModel)
            return taskItem
        }
        return nil
    }
    
    func updateTask(task: TasksScreenModel, objectID: NSManagedObjectID, newValue: Bool) {
        let context = task.context
        if let taskModel = context?.object(with: objectID) as? TasksModel {
            taskModel.taskReady = newValue
            
            do {
                try context?.save()
            } catch {
                print("Не удалось сохранить данные")
            }
        }
    }
    
    func toggleCalendarScope(calendar: FSCalendar, showHideButton: UIButton) {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        }else{
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
}

