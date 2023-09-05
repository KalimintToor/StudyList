//
//  OptionsTasksViewModel.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import CoreData
import UIKit

class OptionsTasksViewModel {
    var model = OptionsTasksModel()
    weak var delegate: OptionsScheduleViewModelDelegate?
    
    func saveButtonTapped() {
        let context = model.context
        
        guard let newTasksOption  = createNewTasksOption(in: context) else {
            return
        }
        
        if shouldSaveTasksOption(newTasksOption) {
            
            do {
                try save(tasksOption: newTasksOption, in: context)
                
                delegate?.viewModelDidShowAlert(title: "Success", message: nil)
            } catch let error as NSError {
                print("Не удалось сохранить. \(error), \(error.userInfo)")
            }
        } else {
            delegate?.viewModelDidShowAlert(title: "Error", message: "Requered fileds: Date, time, name")
            print("Атрибут 1: \(String(describing: model.nameLessonType))")
            print("Атрибут 2: \(String(describing: model.tasksName))")
            print("Атрибут 3: \(String(describing: model.dateTasks))")
            print("Атрибут 4: \(String(describing: model.hexColorCell))")
        }
    }
    
    func pushControllers(viewController: UIViewController) {
        delegate?.viewModelDidRequestPush(viewController: viewController)
    }
}
