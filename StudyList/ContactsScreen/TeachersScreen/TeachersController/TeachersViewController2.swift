//
//  TeachersViewController2.swift
//  StudyList
//
//  Created by Александр on 9/4/23.
//

import UIKit
import CoreData

class TeachersViewController2: UITableViewController {
    
    private var model = TeachersModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        teachersContacts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Teacher"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: idCell.teacherId.rawValue)
    }
    
    private func teachersContacts(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Teacher")
        
        do {
            let result = try model.context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            model.model = fetchedScheduleOptions ?? []
            tableView.reloadData()
//            print(model.count)
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    private func setTeacher(teacher: String){
        let scheduleOptions = self.navigationController?.viewControllers[1] as? OptionsScheduleViewController2
        scheduleOptions?.optionsScheduleViewModel.model.teacherName = teacher
        scheduleOptions?.tableView.reloadRows(at: [[2, 0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.teacherId.rawValue, for: indexPath) as! ContactsTableViewCell
        let modelTeacher = model.model[indexPath.row]
        cell.configure(model: modelTeacher)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelTeacher = model.model[indexPath.row]
        setTeacher(teacher: modelTeacher.contactsName!)
    }
}
