//
//  OptionsScheduleTableViewController.swift
//  StudyList
//
//  Created by Александр on 7/30/23.
//

import UIKit
import CoreData

class OptionsScheduleTableViewController: UITableViewController {
    
    var nameLessonType: String?
    var typeLessonType: String?
    var dateNum: Date?
    var timeNum: Date?
    var weekDays: Int16?
    var audienceNumber: String?
    var buildNumbers: String?
    var repeatSwitch: Bool?
    var teacherName: String?
    
    var scheduleModel: ScheduleModel?
    
    let idOptionsScheduleCell = "idOptionsScheduleCell"
    let idOptionsHeader = "idOptionsHeader"
    let headerNameArray = ["DATA AND TIME", "LESSON", "TEACHER", "COLOR", "PERIOD"]
    var cellNameArray = [["Data", "Time"],
                         ["Name", "Type", "Building", "Audience"],
                         ["Teacher Name"],
                         [""],
                         ["Repeat every 7 days"]]
    
    var hexColorCell = "3DACF7"
    
    var editMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        fetch()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsScheduleCell)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
    }
    
    @objc private func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let container = appDelegate.persistentContainer
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        let entities = container.managedObjectModel.entities
        
        for entity in entities {
            if let entityName = entity.name {
                fetchRequest = NSFetchRequest(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try container.viewContext.execute(deleteRequest)
                } catch let error as NSError {
                    print("Error deleting all data of entity \(entityName): \(error.localizedDescription)")
                }
            }
        }
        
        // Save changes
        appDelegate.saveContext()
    }

    
    @objc private func saveButtonTapped(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Создайте новый объект ScheduleOptions и запустите его в контекст
        
        do{
            
            if let entity = NSEntityDescription.entity(forEntityName: "ScheduleModel", in: context) {
                let newScheduleOption = NSManagedObject(entity: entity, insertInto: context) as? ScheduleModel
                newScheduleOption?.nameLesson = nameLessonType
                newScheduleOption?.typeLesson = typeLessonType
                newScheduleOption?.colorType = hexColorCell
                newScheduleOption?.audienceNumber = audienceNumber
                newScheduleOption?.buildNumber = buildNumbers
                newScheduleOption?.dateNumbers = dateNum
                newScheduleOption?.timeNumbers = timeNum
                newScheduleOption?.teacherName = teacherName
                newScheduleOption?.weekDay = weekDays ?? 1
                newScheduleOption?.scheduleRepeat = repeatSwitch ?? true
                
                if newScheduleOption?.dateNumbers == nil || newScheduleOption?.timeNumbers == nil || newScheduleOption?.nameLesson == ""{
                    alertOkey(title: "Error", message: "Requered fileds: Date, time, name")
                } else {
                try context.save()
                    alertOkey(title: "Success", message: nil)
//                tableView.reloadRows(at: [[1, 0], [1, 1]], with: .none)
                hexColorCell = "3DACF7"
                tableView.reloadData()
                }
            }
        } catch let error as NSError{
            print("Не удалось сохранить. \(error), \(error.userInfo)")
        }
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleModel")

        do {
            // Выполнение запроса
            let result = try context.fetch(fetchRequest)

            // Приведение данных к типу объекта ScheduleOptions, если возможно
            if let fetchedScheduleOptions = result as? [ScheduleModel] {
                // Вывод данных для каждого объекта
                for fetchedScheduleOption in fetchedScheduleOptions {
                    print("Данные объекта ScheduleOptions:")
                    // Вместо listsAttributes используйте имена атрибутов сущности ScheduleOptions
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.nameLesson))")
                    print("Атрибут 2: \(String(describing: fetchedScheduleOption.typeLesson))")
                    print("Цвет ячейки: \(String(describing: fetchedScheduleOption.colorType))")
                    print("date: \(String(describing: fetchedScheduleOption.dateNumbers))")
                    print("time: \(String(describing: fetchedScheduleOption.timeNumbers))")
                    print("week: \(String(describing: fetchedScheduleOption.weekDay))")
                    print("повторения включены: \(String(describing: fetchedScheduleOption.scheduleRepeat))")
                }
            }
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 4
        case 2: return 1
        case 3: return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsScheduleCell, for: indexPath) as! OptionsTableViewCell
        cell.switchRepeatDelegate = self
        cell.cellScheduleConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell, nameTeacher: teacherName ?? "")
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
        
        switch indexPath {
        case [0, 0]: alertDate(label: cell.nameCellLabel) { (numberWeekDay, date) in
            self.dateNum = date
            self.weekDays = Int16(numberWeekDay)
            
        }
        case [0, 1]: alertTime(label: cell.nameCellLabel) { (time) in
            self.timeNum = time
        }
        case [1, 0]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { text in
                self.nameLessonType = text
            }
        case [1, 1]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Type Lesson", placeholder: "Enter type lesson") { text in
                self.typeLessonType = text
            }
        case [1, 2]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Building number", placeholder: "Enter number of building") { text in
                self.buildNumbers = text
            }
        case [1, 3]: alertScheduleOptions(label: cell.nameCellLabel, name: "Audience number", placeholder: "Enter number of audience") { text in
            self.audienceNumber = text
        }
            
        case [2, 0]:
            pushControllers(viewController: TeachersViewController())
        case [3, 0]:
            pushControllers(viewController: ScheduleColorViewContoller())
        default:
            print("no signal")
        }
    }
    
    func pushControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OptionsScheduleTableViewController: SwithRepeatProtocol {
    func switchrepeat(value: Bool) {
        repeatSwitch = value
    }
}
