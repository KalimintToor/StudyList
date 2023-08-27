//
//  OptionsScheduleTableView.swift
//  StudyList
//
//  Created by Александр on 7/31/23.
//

import UIKit
import CoreData

class OptionsTasksTableViewController: UITableViewController {
    
    var nameLessonType: String?
    var tasksName: String?
    var dateTasks: Date?
    var weekDays: Int16?
    var hexColorCell = "3DACF7"
    
    let idOptionsTasksCell = "idOptionsTasksCell"
    let idOptionsHeader = "idOptionsTasksHeader"
    
    let headerNameArray = ["DATA", "LESSON", "TASK", "COLOR"]
    let cellNameArray = ["Date", "Lesson", "Tasks", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsTasksCell)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func saveButtonTapped(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TasksModel", in: context)!
        let newTasksOption = NSManagedObject(entity: entity, insertInto: context) as? TasksModel
        newTasksOption?.lessonName = nameLessonType
        newTasksOption?.tasksName = tasksName
        newTasksOption?.dateNumbers = dateTasks
        newTasksOption?.colorType = hexColorCell
        newTasksOption?.weekDay = weekDays!
        // Создайте новый объект ScheduleOptions и запустите его в контекст
        
        do{
            if newTasksOption?.dateNumbers == nil || newTasksOption?.lessonName == ""{
                alertOkey(title: "Error", message: "Requered fileds: Date, name task")
            } else {
                try context.save()
                alertOkey(title: "Success", message: nil)
    //                tableView.reloadRows(at: [[1, 0], [1, 1]], with: .none)
                tableView.reloadData()
                fetch()
            }
        } catch let error as NSError{
            print("Не удалось сохранить. \(error), \(error.userInfo)")
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
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.lessonName))")
                    print("Атрибут 2: \(String(describing: fetchedScheduleOption.tasksName))")
                    print("Атрибут 3: \(String(describing: fetchedScheduleOption.dateNumbers))")
                    print("Атрибут 4: \(String(describing: fetchedScheduleOption.colorType))")
                }
            }
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsTasksCell, for: indexPath) as! OptionsTableViewCell
        cell.cellTasksConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsHeader) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath.section {
        case 0: alertDate(label: cell.nameCellLabel) { (numberWeekDay, date) in
            self.weekDays = Int16(numberWeekDay)
            self.dateTasks = date
        }
        case 1: alertForCellName(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { text in
            self.nameLessonType = text
        }
        case 2: alertForCellName(label: cell.nameCellLabel, name: "Name Task", placeholder: "Enter name task") { (text) in
            self.tasksName = text
        }
        case 3: pushControllers(viewController: TaskColorViewController())
        default:
            print("no signal")
        }
    }
    
    func pushControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
