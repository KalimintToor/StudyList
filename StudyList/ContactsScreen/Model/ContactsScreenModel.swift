//
//  ContactsScreenModel.swift
//  StudyList
//
//  Created by Александр on 8/28/23.
//

import UIKit
import CoreData

class ContactsScreenModel {
    var model: [Contacts] = []
    var filteredContacts: [Contacts] = []
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    func fetchContactsOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            model = fetchedScheduleOptions ?? []
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
    
    func deleteContacts(at indexPath: IndexPath) {
        let contactsToDelete = model[indexPath.row]
        
        context.delete(contactsToDelete)
        
        do {
            try context.save()
            model.remove(at: indexPath.row)
//            self.
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }
    
    func getFilteredModel(indexPath: IndexPath) -> Contacts? {
        if indexPath.row >= 0 && indexPath.row < filteredContacts.count {
            return filteredContacts[indexPath.row]
        } else {
            print("Ошибка: Index out of range")
            return nil // Возвращаем nil вместо значения по умолчанию
        }
    }
    
    func getModel(indexPath: IndexPath) -> Contacts? {
        if indexPath.row >= 0 && indexPath.row < model.count {
            return model[indexPath.row]
        } else {
            print("Ошибка: Index out of range")
            return nil // Возвращаем nil вместо значения по умолчанию
        }
    }
    
    func countFilteredModel() -> Int{
        return filteredContacts.count
    }
    
    func countModel() -> Int{
        return model.count
    }
}
