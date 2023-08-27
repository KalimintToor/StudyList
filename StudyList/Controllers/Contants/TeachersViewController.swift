//
//  TeachersViewController.swift
//  StudyList
//
//  Created by Александр on 7/31/23.
//

import UIKit
import CoreData

class TeachersViewController: UITableViewController {
    
    private var model: [Contacts] = []
    private let teacherId = "teacherId"
    
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
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: teacherId)
    }
    
    private func teachersContacts(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Teacher")
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            model = fetchedScheduleOptions ?? []
            tableView.reloadData()
            print(model.count)
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    private func setTeacher(teacher: String){
        let scheduleOptions = self.navigationController?.viewControllers[1] as? OptionsScheduleTableViewController
        scheduleOptions?.teacherName = teacher
        scheduleOptions?.tableView.reloadRows(at: [[2, 0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teacherId, for: indexPath) as! ContactsTableViewCell
        let modelTeacher = model[indexPath.row]
        cell.configure(model: modelTeacher)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelTeacher = model[indexPath.row]
        setTeacher(teacher: modelTeacher.contactsName!)
    }
}


