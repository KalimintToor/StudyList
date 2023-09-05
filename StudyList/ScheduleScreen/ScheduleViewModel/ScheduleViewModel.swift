//
//  ScheduleViewModel.swift
//  StudyList
//
//  Created by Александр on 8/26/23.
//

import CoreData
import FSCalendar

class ScheduleViewModel {
    let model = ScheduleScreenModel()
    
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
            if let timeNumbers1 = schedule1.timeNumbers, let timeNumbers2 = schedule2.timeNumbers {
                return timeNumbers1 < timeNumbers2
            }
            return false
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


