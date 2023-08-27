//
//  ScheduleScreenModel.swift
//  StudyList
//
//  Created by Александр on 8/26/23.
//

import UIKit
import CoreData

class ScheduleScreenModel{
    var model: [ScheduleModel] = []
    private(set) var filteredSchedules: [ScheduleModel] = []
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func fetchScheduleOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleModel")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [ScheduleModel]
            model = fetchedScheduleOptions ?? []
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    func deleteSchedule(at indexPath: IndexPath) {
        let scheduleToDelete = filteredSchedules[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(scheduleToDelete)
        
        do {
            try context.save()
            filteredSchedules.remove(at: indexPath.row)
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }
    
    func getModel(indexPath: IndexPath) -> ScheduleModel? {
        if indexPath.row >= 0 && indexPath.row < filteredSchedules.count {
            return filteredSchedules[indexPath.row]
        } else {
            print("Ошибка: Index out of range")
            return nil // Возвращаем nil вместо значения по умолчанию
        }
    }
    
    func updateFilteredSchedules(_ schedules: [ScheduleModel]) {
        print(schedules.count)
        filteredSchedules = schedules
    }
    
    func countModel() -> Int{
        return filteredSchedules.count
    }
}
