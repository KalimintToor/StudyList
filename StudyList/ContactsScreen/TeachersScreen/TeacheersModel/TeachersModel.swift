//
//  TeachersModel.swift
//  StudyList
//
//  Created by Александр on 9/4/23.
//

import UIKit
import CoreData

struct TeachersModel {
    var model: [Contacts] = []
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
}
