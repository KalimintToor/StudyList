//
//  ScheduleView.swift
//  StudyList
//
//  Created by Александр on 8/25/23.
//

import UIKit
import FSCalendar
import CoreData

class ScheduleView: UIView {
    
    private let idScheduleCell = "idScheduleCell"
    var calendarHeightConstraint: NSLayoutConstraint!
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Calendar", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.bounces = false //отключение прыгания списка таблицы
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(calendar)
        addSubview(showHideButton)
        addSubview(tableView)
        
        setConstraints()
    }
}
