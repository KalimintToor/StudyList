//
//  OptionsTasksModel.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import UIKit
import CoreData

struct OptionsTasksModel {
    var nameLessonType: String?
    var tasksName: String?
    var dateTasks: Date?
    var hexColorCell = "3DACF7"
    
    let headerNameArray = ["DATA", "LESSON", "TASK", "COLOR"]
    let cellNameArray = ["Date", "Lesson", "Tasks", ""]
    
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
}
