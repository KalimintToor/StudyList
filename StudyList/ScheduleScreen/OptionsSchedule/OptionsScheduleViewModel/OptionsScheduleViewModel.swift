//
//  OptionsScheduleViewModel.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import UIKit
import CoreData

class OptionsScheduleViewModel {
    var model = OptionsScheduleModel()
    weak var delegate: OptionsScheduleViewModelDelegate?
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    func saveButtonTapped() {
        let context = model.context
        
        guard let newScheduleOption = createNewScheduleOption(in: context) else {
            return
        }
        
        if shouldSaveScheduleOption(newScheduleOption) {
            
            do {
                try save(scheduleOption: newScheduleOption, in: context)
                delegate?.viewModelDidShowAlert(title: "Success", message: nil)
            } catch let error as NSError {
                print("Не удалось сохранить. \(error), \(error.userInfo)")
            }
        } else {
            delegate?.viewModelDidShowAlert(title: "Error", message: "Requered fileds: Date, time, name")
        }
    }
    
    func pushControllers(viewController: UIViewController) {
        delegate?.viewModelDidRequestPush(viewController: viewController)
    }

    
    func fetch(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksModel")

        do {
            // Выполнение запроса
            let result = try context.fetch(fetchRequest)

            // Приведение данных к типу объекта ScheduleOptions, если возможно
            if let fetchedScheduleOptions = result as? [TasksModel] {
                // Вывод данных для каждого объекта
                for fetchedScheduleOption in fetchedScheduleOptions {
                    print("Данные объекта ScheduleOptions:")
                    // Вместо listsAttributes используйте имена атрибутов сущности ScheduleOptions
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.lessonName))")
                    print("Атрибут 2: \(String(describing: fetchedScheduleOption.tasksName))")
                    print("Атрибут 3: \(String(describing: fetchedScheduleOption.dateNumbers))")
                    print("Атрибут 4: \(String(describing: fetchedScheduleOption.colorType))")
                }
            }
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    func switchrepeat(value: Bool) {
        model.repeatSwitch = value
    }
}
