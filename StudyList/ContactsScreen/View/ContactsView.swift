//
//  ContactsView.swift
//  StudyList
//
//  Created by Александр on 8/28/23.
//

import UIKit

class ContactsView: UIView {

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    let searchConttroller = UISearchController()

    var searchBarIsEmpty: Bool {
        guard let text = searchConttroller.searchBar.text else {return true}
        return text.isEmpty
    }
    
    var isFiltred: Bool {
        return searchConttroller.isActive && !searchBarIsEmpty
    }
    
}
