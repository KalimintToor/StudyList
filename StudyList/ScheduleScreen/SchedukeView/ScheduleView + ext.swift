//
//  ScheduleView + ext.swift
//  StudyList
//
//  Created by Александр on 8/25/23.
//

import UIKit
import FSCalendar
import CoreData

extension ScheduleView {
    //MARK: АНИМАЦИЯ ТАБЛИЦЫ
    func setConstraints() {
        addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
        
        addSubview(showHideButton)
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 100),
            showHideButton.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    
    
}
