//
//  ContactsViewModel.swift
//  StudyList
//
//  Created by Александр on 8/28/23.
//

import UIKit
import CoreData

class ContactsViewModel {
    
    private var model = ContactsScreenModel()
    weak var delegate: ContactsViewModelDelegate?
    
    init(model: ContactsScreenModel) {
        self.model = model
    }
    
    func applySegmentedFilter(selectedSegmentTitle: String, isFiltred: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")

        if selectedSegmentTitle == "Friends" {
            fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Friend")
        } else if selectedSegmentTitle == "Teachers" {
            fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Teacher")
        }

        do {
            let result = try model.context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            model.model = fetchedScheduleOptions ?? []
            delegate?.updateContactsTableView()
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }

    func filterContentForSearchText(_ searchText: String, segmentedControl: UISegmentedControl, isFiltred: Bool){


        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        fetchRequest.predicate = NSPredicate(format: "contactsType == %@", segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "")
        if !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "contactsName CONTAINS[c] %@", searchText)
        }

        do {
            let result = try model.context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            model.filteredContacts = fetchedScheduleOptions ?? []
            delegate?.updateContactsTableView()
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
}
