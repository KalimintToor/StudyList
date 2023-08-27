//
//  ScheduleViewModel.swift
//  StudyList
//
//  Created by Александр on 8/26/23.
//

import CoreData
import UIKit
import FSCalendar

class ScheduleViewModel {
    private var model = ScheduleScreenModel()
    private(set) var filteredSchedules: [ScheduleModel] = []
    
    init(model: ScheduleScreenModel) {
        self.model = model
    }
    
    func scheduleOnDay(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }
        
        let filtered = model.model.filter { model in
            if model.scheduleRepeat, model.weekDay == weekday {
                return true
            }
            
            if let scheduleDate = model.dateNumbers {
                return Calendar.current.isDate(date, inSameDayAs: scheduleDate)
            }
            
            return false
        }.sorted { (schedule1, schedule2) -> Bool in
            return schedule1.timeNumbers! < schedule2.timeNumbers!
        }
        
        model.updateFilteredSchedules(filtered)
    }
    
    func showHideButtonTapped(calendar: FSCalendar, showHideButton: UIButton){
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        }else{
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
}


