//
//  TasksViewController2.swift
//  StudyList
//
//  Created by Александр on 8/27/23.
//

import UIKit
import CoreData
import FSCalendar

class TasksViewController2: UIViewController{
    private let model = TasksScreenManager()
    private lazy var viewModel = TasksViewModel(model: model)
    
    
    private lazy var tasksView: TasksView = {
        let view = TasksView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel.fetchTasksOptions()
            tasksOnDay(date: Date())
            print(viewModel.numberOfTasks())
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        view.backgroundColor = .white

        tasksView.calendar.delegate = self
        tasksView.calendar.dataSource = self
        tasksView.calendar.scope = .week

        tasksView.tableView.dataSource = self
        tasksView.tableView.delegate = self
        tasksView.tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: idCell.idTasksCell.rawValue )
        
        
        viewModel.onTasksUpdated = { [weak self] in
            self?.tasksView.tableView.reloadData()
        }


        tasksView.showHideButton.addTarget(self, action: #selector(buttonCalendar), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        setupLayout()
    }
    
    @objc func addButtonTapped(){
        let tasksOption = OptionsTasksViewController2()
        navigationController?.pushViewController(tasksOption, animated: true)
    }
    
    @objc func buttonCalendar(){
        viewModel.toggleCalendarScope(calendar: tasksView.calendar, showHideButton: tasksView.showHideButton)
    }
    
    private func tasksOnDay(date: Date) {
        viewModel.tasksOnDay(date: date)
    }
    
    private func deleteSchedule(at indexPath: IndexPath) {
        viewModel.deleteTask(at: indexPath)
        tasksView.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    private func setupLayout() {
        view.addSubview(tasksView)
        NSLayoutConstraint.activate([
            tasksView.topAnchor.constraint(equalTo: view.topAnchor),
            tasksView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tasksView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: FSCalendarDataSource, FSCalendarDelegate

extension TasksViewController2: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        tasksView.calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasksOnDay(date: date)
    }
    
}

//MARK: TableViewDelegate, TableViewDataSource

extension TasksViewController2: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idTasksCell.rawValue, for: indexPath) as! TasksTableViewCell
        cell.managedObjectContext = model.managedObjectContext
        if let taskItem = viewModel.taskItem(at: indexPath) {
            cell.configure(taskItem: taskItem)
        }
        
        cell.cellTaskDelegate = self
        
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

//MARK: PressReadyTaskButtonProtocol

extension TasksViewController2: TaskReadyDelegate {
    func taskReadyDidChange(objectID: NSManagedObjectID, newValue: Bool) {
        let context = model.managedObjectContext
        
        if let task = context.object(with: objectID) as? TasksModel {
            task.taskReady = newValue
            
            do {
                try context.save()
            } catch {
                print("Не удалось сохранить данные")
            }
        }
    }
}
