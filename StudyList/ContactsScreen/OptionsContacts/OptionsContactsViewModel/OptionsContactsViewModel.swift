//
//  OptionsContactsViewModel.swift
//  StudyList
//
//  Created by Александр on 9/3/23.
//

import CoreData
import UIKit

class OptionsContactsViewModel {
    var model: OptionsContactsModel = OptionsContactsModel()
    weak var delegate: OptionsScheduleViewModelDelegate?
    
    func saveButtonTapped() {
        let context = model.context
        
        guard let newContactsOption  = createNewContactsOption(in: context) else {
            return
        }
        
        if shouldSaveContactsOption(newContactsOption) {
            
            do {
                try save(contactsOption: newContactsOption, in: context)
                
                delegate?.viewModelDidShowAlert(title: "Success", message: nil)
            } catch let error as NSError {
                print("Не удалось сохранить. \(error), \(error.userInfo)")
            }
        } else {
            delegate?.viewModelDidShowAlert(title: "Error", message: "Requered fileds: NAME and TYPE")
        }
    }
    
    func pushControllers(viewController: UIViewController) {
        delegate?.viewModelDidRequestPush(viewController: viewController)
    }
}


extension OptionsContactsViewModel{
    func createNewContactsOption(in context: NSManagedObjectContext) -> Contacts? {
        if let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: context) {
            let newContactsOption = NSManagedObject(entity: entity, insertInto: context) as? Contacts
            newContactsOption?.contactsName = model.nameContacts
            newContactsOption?.contactsPhone = model.phoneContacts
            newContactsOption?.contactsMail = model.mailContacts
            newContactsOption?.contactsType = model.typeContacts
            newContactsOption?.contactsImage = model.imageContacts
            return newContactsOption
        }
        return nil
    }
    func shouldSaveContactsOption(_ contactsOption: Contacts) -> Bool {
        return contactsOption.contactsName != nil && contactsOption.contactsType != ""
    }
    
    func save(contactsOption: Contacts, in context: NSManagedObjectContext) throws {
        try context.save()
    }
}
