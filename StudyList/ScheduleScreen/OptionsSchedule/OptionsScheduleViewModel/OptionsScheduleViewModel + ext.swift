//
//  OptionsScheduleViewModel + ext.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

//import UIKit
import CoreData

extension OptionsScheduleViewModel {
    func createNewScheduleOption(in context: NSManagedObjectContext) -> ScheduleModel? {
        if let entity = NSEntityDescription.entity(forEntityName: "ScheduleModel", in: context) {
            let newScheduleOption = NSManagedObject(entity: entity, insertInto: context) as? ScheduleModel
            newScheduleOption?.nameLesson = model.nameLessonType
            newScheduleOption?.typeLesson = model.typeLessonType
            newScheduleOption?.colorType = model.hexColorCell
            newScheduleOption?.audienceNumber = model.audienceNumber
            newScheduleOption?.buildNumber = model.buildNumbers
            newScheduleOption?.dateNumbers = model.dateNum
            newScheduleOption?.timeNumbers = model.timeNum
            newScheduleOption?.teacherName = model.teacherName
            newScheduleOption?.weekDay = model.weekDays ?? 1
            newScheduleOption?.scheduleRepeat = model.repeatSwitch ?? true
            return newScheduleOption
        }
        return nil
    }
    func shouldSaveScheduleOption(_ scheduleOption: ScheduleModel) -> Bool {
        return scheduleOption.dateNumbers != nil && scheduleOption.timeNumbers != nil && scheduleOption.nameLesson != ""
    }
    
    func save(scheduleOption: ScheduleModel, in context: NSManagedObjectContext) throws {
        try context.save()
    }
        
    
}
