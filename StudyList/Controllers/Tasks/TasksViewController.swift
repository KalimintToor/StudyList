//
//  TasksViewController.swift
//  StudyList
//
//  Created by Александр on 7/29/23.
//

import UIKit
import FSCalendar
import CoreData

class TasksViewController: UIViewController {
    
    private var model1: [TasksModel] = []
    private var filteredTasks: [TasksModel] = []
    var managedObjectContext: NSManagedObjectContext!
    var delegate: TaskReadyDelegate?
    var task: TasksModel?
    
    var calendarHeightConstraint: NSLayoutConstraint!
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Calendar", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tabelView: UITableView = {
        let table = UITableView()
        table.bounces = false //отключение прыгания списка таблицы
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let idTasksCell = "idTasksCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScheduleOptions()
        tasksOnDay(date: Date())
        print(task?.taskReady)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tasks"
        view.backgroundColor = .white
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.register(TasksTableViewCell.self, forCellReuseIdentifier: idTasksCell)
        
        setConstraints()
        swipeAction()
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func fetchScheduleOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksModel")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [TasksModel]
            model1 = fetchedScheduleOptions ?? []
            print(model1.count)
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    @objc func addButtonTapped(){
        let tasksOption = OptionsTasksTableViewController()
        navigationController?.pushViewController(tasksOption, animated: true)
    }
    
    @objc func showHideButtonTapped(){
        fetch()
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        }else{
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TasksModel")

        do {
            // Выполнение запроса
            let result = try context.fetch(fetchRequest)

            // Приведение данных к типу объекта ScheduleOptions, если возможно
            if let fetchedScheduleOptions = result as? [TasksModel] {
                // Вывод данных для каждого объекта
                for fetchedScheduleOption in fetchedScheduleOptions {
                    print("Данные объекта ScheduleOptions:")
                    // Вместо listsAttributes используйте имена атрибутов сущности ScheduleOptions
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.tasksName))")
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.lessonName))")
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.taskReady))")
                }
            }
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: SwipeGestureRecognizer
    
    func swipeAction(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        switch gesture.direction {
        case .up:
            showHideButtonTapped()
        case .down:
            showHideButtonTapped()
        default:
            break
        }
    }
    
    private func tasksOnDay(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }

        // Фильтруем основной массив model1, чтобы получить модели с соответствующими параметрами.
        filteredTasks = model1.filter { model in
            if model.weekDay == weekday {
                return true
            }

            if let tasksDate = model.dateNumbers {
                return Calendar.current.isDate(date, inSameDayAs: tasksDate)
            }
            
            return false
        }

        tabelView.reloadData()
    }
}

//MARK: FSCalendarDataSource, FSCalendarDelegate

extension TasksViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasksOnDay(date: date)
    }
    
    private func deleteSchedule(at indexPath: IndexPath) {
        let scheduleToDelete = filteredTasks[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(scheduleToDelete)
        
        do {
            try context.save()
            filteredTasks.remove(at: indexPath.row)
            self.tabelView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }
}

//MARK: TableViewDelegate, TableViewDataSource

extension TasksViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTasksCell, for: indexPath) as! TasksTableViewCell
        cell.managedObjectContext = managedObjectContext
        let model = filteredTasks[indexPath.row]
        cell.configure(model: model)
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



extension TasksViewController: TaskReadyDelegate {
    func taskReadyDidChange(newTaskReady: Bool) {
        print(newTaskReady)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Создание нового объекта в Core Data
        let entity = NSEntityDescription.entity(forEntityName: "TasksModel", in: context)
        let task = NSManagedObject(entity: entity!, insertInto: context)
        
        // Установка значений атрибутов объекта
        task.setValue(newTaskReady, forKey: "taskReady")
        
        // Сохранение изменений
        do {
            try context.save()
        } catch {
            print("Не удалось сохранить данные")
        }
    }
}

//MARK: SetConstraints

extension TasksViewController {
    func setConstraints(){
        view.addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        view.addSubview(showHideButton)
        
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.widthAnchor.constraint(equalToConstant: 100),
            showHideButton.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        view.addSubview(tabelView)
        NSLayoutConstraint.activate([
            tabelView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
