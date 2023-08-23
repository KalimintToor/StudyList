//
//  ScheduleViewController.swift
//  StudyList
//
//  Created by Александр on 7/29/23.
//

import UIKit
import FSCalendar
import CoreData

class ScheduleViewController: UIViewController{
    
    
    private var model1: [ScheduleModel] = []
    private var filteredSchedules: [ScheduleModel] = []

    
    private var calendarHeightConstraint: NSLayoutConstraint!
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private let showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Calendar", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tabelView: UITableView = {
        let table = UITableView()
        table.bounces = false //отключение прыгания списка таблицы
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    
    private let idScheduleCell = "idScheduleCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScheduleOptions()
        scheduleOnDay(date: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        view.backgroundColor = .white
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idScheduleCell)
        
        setConstraints()
        
        swipeAction()
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
    }
    
    private func fetchScheduleOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleModel")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [ScheduleModel]
            model1 = fetchedScheduleOptions ?? []
//            print(model1.count)
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    @objc func addButtonTapped(){
        
        let scheduleOption = OptionsScheduleTableViewController()
        navigationController?.pushViewController(scheduleOption, animated: true)
    }
    
    @objc func showHideButtonTapped(){
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        }else{
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
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
    
    private func scheduleOnDay(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }

        // Фильтруем основной массив model1, чтобы получить модели с соответствующими параметрами.
        filteredSchedules = model1.filter { model in
            if model.scheduleRepeat, model.weekDay == weekday {
                return true
            }

            if let scheduleDate = model.dateNumbers {
                return Calendar.current.isDate(date, inSameDayAs: scheduleDate)
            }
            
            return false
        }
        
        filteredSchedules.sort { (schedule1, schedule2) -> Bool in
            return schedule1.timeNumbers! < schedule2.timeNumbers!
        }

        tabelView.reloadData()
    }
    
    private func deleteSchedule(at indexPath: IndexPath) {
        let scheduleToDelete = filteredSchedules[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(scheduleToDelete)
        
        do {
            try context.save()
            filteredSchedules.remove(at: indexPath.row)
            self.tabelView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }

}

//MARK: TableViewDelegate, TableViewDataSource

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchedules.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idScheduleCell, for: indexPath) as! ScheduleTableViewCell
        let model = filteredSchedules[indexPath.row]
        cell.configure(model: model) // Вызовите configure с переданным моделью.
        
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

extension ScheduleViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) { //date получаем при нажатии на календарь
        scheduleOnDay(date: date)
        
    }
}

//MARK: SetConstraints

extension ScheduleViewController {
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
