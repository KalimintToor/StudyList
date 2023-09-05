//
//  OptionsScheduleModel.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import UIKit
import CoreData

struct OptionsScheduleModel {
    var nameLessonType: String?
    var typeLessonType: String?
    var dateNum: Date?
    var timeNum: Date?
    var weekDays: Int16?
    var audienceNumber: String?
    var buildNumbers: String?
    var repeatSwitch: Bool?
    var teacherName: String?
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    let headerNameArray = ["DATA AND TIME", "LESSON", "TEACHER", "COLOR", "PERIOD"]
    var cellNameArray = [["Data", "Time"],
                         ["Name", "Type", "Building", "Audience"],
                         ["Teacher Name"],
                         [""],
                         ["Repeat every 7 days"]]
    
    let idOptionsScheduleCell = "idOptionsScheduleCell"
    let idOptionsHeader = "idOptionsHeader"
    
    var hexColorCell = "3DACF7"
    var editMode = false
}
