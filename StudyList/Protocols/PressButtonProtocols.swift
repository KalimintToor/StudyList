//
//  PressButtonProtocols.swift
//  StudyList
//
//  Created by Александр on 7/30/23.
//

import CoreData
import UIKit

protocol TaskReadyDelegate: AnyObject {
    func taskReadyDidChange(objectID: NSManagedObjectID, newValue: Bool)
}

protocol SwithRepeatProtocol: class {
    func switchrepeat(value: Bool)
}

protocol ContactsViewModelDelegate: AnyObject {
    func updateContactsTableView()
}

protocol ColorSelectionDelegate: AnyObject {
    func didSelectColor(color: String)
}

protocol OptionsColorsViewModelDelegate: AnyObject {
    func viewModelDidRequestPush(viewController: UIViewController)
}

protocol OptionsScheduleViewModelDelegate: AnyObject {
    func viewModelDidShowAlert(title: String, message: String?)
    func viewModelDidRequestPush(viewController: UIViewController)
}
