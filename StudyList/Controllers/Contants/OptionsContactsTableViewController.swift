//
//  OptionsContactsTableViewController.swift
//  StudyList
//
//  Created by Александр on 8/2/23.
//

import UIKit
import CoreData

class OptionsContactsTableViewController: UITableViewController {
    
    var nameContacts: String?
    var phoneContacts: String?
    var mailContacts: String?
    var typeContacts: String?
    var imageContacts: Data?
    
    let idContactsScheduleCell = "idContactsScheduleCell"
    let idContactsHeader = "idContactsHeader"
    
    let headerNameArray = ["NAME", "PHONE", "MAIL", "TYPE", "CHOOSE IMAGE"]
    
    let cellNameArray = ["Name", "Phone", "Mail", "Type", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idContactsScheduleCell)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idContactsHeader)
        
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
        
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: context)!
        let newContactsOption = NSManagedObject(entity: entity, insertInto: context) as? Contacts
        newContactsOption?.contactsName = nameContacts
        newContactsOption?.contactsPhone = phoneContacts
        newContactsOption?.contactsMail = mailContacts
        newContactsOption?.contactsType = typeContacts
        newContactsOption?.contactsImage = imageContacts
        // Создайте новый объект ScheduleOptions и запустите его в контекст
        
        do{
            
            if newContactsOption?.contactsName == "" || newContactsOption?.contactsType == "" {
                alertOkey(title: "Error", message: "Requered fileds: NAME and TYPE")
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")

        do {
            // Выполнение запроса
            let result = try context.fetch(fetchRequest)

            // Приведение данных к типу объекта ScheduleOptions, если возможно
            if let fetchedScheduleOptions = result as? [Contacts] {
                // Вывод данных для каждого объекта
                for fetchedScheduleOption in fetchedScheduleOptions {
                    print("Данные объекта ScheduleOptions:")
                    // Вместо listsAttributes используйте имена атрибутов сущности ScheduleOptions
                    print("Атрибут 1: \(String(describing: fetchedScheduleOption.contactsName))")
                    print("Атрибут 2: \(String(describing: fetchedScheduleOption.contactsType))")
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
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idContactsScheduleCell, for: indexPath) as! OptionsTableViewCell
        cell.cellContactsConfigure(nameArray: cellNameArray, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 4 ? 200 : 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idContactsHeader) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath.section {
        case 0: alertForCellName(label: cell.nameCellLabel, name: "Name Contact", placeholder: "Enter name contact") { (text) in
            self.nameContacts = text
        }
        case 1: alertForCellName(label: cell.nameCellLabel, name: "Phone Contact", placeholder: "Enter phone contact") { (text) in
            
            self.phoneContacts = text
        }
        case 2: alertForCellName(label: cell.nameCellLabel, name: "Mail Contact", placeholder: "Enter mail contact") { (text) in
            
            self.mailContacts = text
        }
        case 3: alertFriendOrTeacher(label: cell.nameCellLabel) { (type) in
            self.typeContacts = type
        }
        case 4: alertPhotoCamera { (source) in
            self.chooseImagePicker(source: source)
        }
        default:
            print("tap on cell")
        }
    }
    
    func pushControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OptionsContactsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let cell = tableView.cellForRow(at: [4, 0]) as! OptionsTableViewCell
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        dismiss(animated: true)
    }
}
