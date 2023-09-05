//
//  OptionsContactsModel.swift
//  StudyList
//
//  Created by Александр on 9/3/23.
//

import CoreData
import UIKit

struct OptionsContactsModel {
    
    var nameContacts: String?
    var defImageContacts = "person.fill"
    var phoneContacts = "Unknown"
    var mailContacts = "Unknown"
    var typeContacts: String?
    var imageContacts: Data?
    
    let headerNameArray = ["NAME", "PHONE", "MAIL", "TYPE", "CHOOSE IMAGE"]
    
    let cellNameArray = ["Name", "Phone", "Mail", "Type", ""]
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
}
