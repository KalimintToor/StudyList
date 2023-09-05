//
//  ScheduleViewController2.swift
//  StudyList
//
//  Created by Александр on 8/25/23.
//

import UIKit
import FSCalendar
import CoreData

class ScheduleViewController3: UIViewController {
    private lazy var viewModel = ScheduleViewModel()
    
    private lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.model.fetchScheduleOptions()
        scheduleOnDay(date: Date())
        print(viewModel.model.countModel())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        view.backgroundColor = .white

        scheduleView.calendar.delegate = self
        scheduleView.calendar.dataSource = self
        scheduleView.calendar.scope = .week

        scheduleView.tableView.dataSource = self
        scheduleView.tableView.delegate = self
        scheduleView.tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idCell.idScheduleCell.rawValue)

        scheduleView.showHideButton.addTarget(self, action: #selector(buttonCalendar), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        setupLayout()
    }
    
    @objc func addButtonTapped(){
        
        let scheduleOption = OptionsScheduleViewController2()
        navigationController?.pushViewController(scheduleOption, animated: true)
    }
    
    @objc func buttonCalendar(){
        viewModel.showHideButtonTapped(calendar: scheduleView.calendar, showHideButton: scheduleView.showHideButton)
    }
    
    private func scheduleOnDay(date: Date){
        viewModel.scheduleOnDay(date: date)
        scheduleView.tableView.reloadData()
    }
    
    private func deleteSchedule(at indexPath: IndexPath){
        viewModel.model.deleteSchedule(at: indexPath)
        scheduleView.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    private func setupLayout() {
        view.addSubview(scheduleView)
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: view.topAnchor),
            scheduleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ScheduleViewController3: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.countModel()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idScheduleCell.rawValue, for: indexPath) as! ScheduleTableViewCell
        if let schedule = viewModel.model.getModel(indexPath: indexPath) {//getModel(indexPath: indexPath) {
            cell.configure(model: schedule) // Вызовите configure с переданным моделью.
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteSchedule(at: indexPath)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .red
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
    }
}

//MARK: FSCalendarDataSource, FSCalendarDelegate

extension ScheduleViewController3: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        scheduleView.calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) { //date получаем при нажатии на календарь
        print(date)
        scheduleOnDay(date: date)
        
    }
}
