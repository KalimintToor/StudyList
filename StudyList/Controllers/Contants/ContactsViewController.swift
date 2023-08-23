//
//  ContactsViewController.swift
//  StudyList
//
//  Created by Александр on 8/2/23.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {
    
    private var model: [Contacts] = []
    private var filteredContacts: [Contacts] = []
    
    let idContactsCell = "idContactsCell"
    
    let searchConttroller = UISearchController()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    //проверяет пустой ли сеарч бар, если тебе не понятно, то напиши print(searchBarIsEmpty) в методе filterContentForSearchText
    var searchBarIsEmpty: Bool {
        guard let text = searchConttroller.searchBar.text else {return true}
        return text.isEmpty
    }
    
    var isFiltred: Bool {
        return searchConttroller.isActive && !searchBarIsEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContactsOptions()
        applySegmentedFilter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .white
        
        searchConttroller.searchBar.placeholder = "Search"
        navigationItem.searchController = searchConttroller
        
        searchConttroller.obscuresBackgroundDuringPresentation = false
        
        searchConttroller.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: idContactsCell)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        
        setConstraints()
    }
    
    @objc private func segmentedChange(){
        applySegmentedFilter()
    }
    
    private func applySegmentedFilter() {
        guard let selectedSegmentTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else {return}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        if selectedSegmentTitle == "Friends" {
            fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Friend")
        } else if selectedSegmentTitle == "Teachers" {
            fetchRequest.predicate = NSPredicate(format: "contactsType == %@", "Teacher")
        }
        
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
    
    @objc func addButtonTapped(){
        let contactOption = OptionsContactsTableViewController()
        navigationController?.pushViewController(contactOption, animated: true)
    }
    
    private func fetchContactsOptions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
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
    
    private func deleteContacts(at indexPath: IndexPath) {
        let contactsToDelete = model[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(contactsToDelete)
        
        do {
            try context.save()
            model.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Не удалось удалить данные. \(error), \(error.userInfo)")
        }
    }
    
    
}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isFiltred ? filteredContacts.count : model.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idContactsCell, for: indexPath) as! ContactsTableViewCell
        let modelContacts = (isFiltred ? filteredContacts[indexPath.row] : model[indexPath.row])
        cell.configure(model: modelContacts)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteContacts(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

extension ContactsViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchConttroller.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        // Добавляем предикат для поиска
        fetchRequest.predicate = NSPredicate(format: "contactsType == %@", segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "")
        
        if !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "contactsName CONTAINS[c] %@", searchText)
        }
        
        do {
            let result = try context.fetch(fetchRequest)
            let fetchedScheduleOptions = result as? [Contacts]
            filteredContacts = fetchedScheduleOptions ?? []
            tableView.reloadData()
            print(filteredContacts.count)
        } catch let error as NSError {
            print("Не удалось получить данные. \(error), \(error.userInfo)")
        }
    }
}

extension ContactsViewController{
    private func setConstraints(){
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView], axis: .vertical, spacing: 0, distribution: .equalSpacing)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
    }
}
