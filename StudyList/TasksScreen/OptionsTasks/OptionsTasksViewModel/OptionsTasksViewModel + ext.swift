//
//  OptionsTasksViewModel + ext.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import CoreData

extension OptionsTasksViewModel {
    func createNewTasksOption(in context: NSManagedObjectContext) -> TasksModel? {
        if let entity = NSEntityDescription.entity(forEntityName: "TasksModel", in: context) {
            let newTasksOption = NSManagedObject(entity: entity, insertInto: context) as? TasksModel
            newTasksOption?.lessonName = model.nameLessonType
            newTasksOption?.tasksName = model.tasksName
            newTasksOption?.dateNumbers = model.dateTasks
            newTasksOption?.colorType = model.hexColorCell
            return newTasksOption
        }
        return nil
    }
    func shouldSaveTasksOption(_ tasksOption: TasksModel) -> Bool {
        return tasksOption.dateNumbers != nil && tasksOption.lessonName != ""
    }
    
    func save(tasksOption: TasksModel, in context: NSManagedObjectContext) throws {
        try context.save()
    }
        
    
}
