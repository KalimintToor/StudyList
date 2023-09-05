//
//  ContactsViewController2.swift
//  StudyList
//
//  Created by Александр on 8/28/23.
//

import UIKit
import CoreData

class ContactsViewController2: UIViewController {
    
    private let model = ContactsScreenModel()
    private lazy var viewModel = ContactsViewModel(model: model)
    
    private lazy var contactsView: ContactsView = {
        let view = ContactsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContactsOptions()
        applySegmentedFilter()
        updateContactsTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .white
        
        contactsView.searchConttroller.searchBar.placeholder = "Search"
        navigationItem.searchController = contactsView.searchConttroller
        
        contactsView.searchConttroller.obscuresBackgroundDuringPresentation = false
        
        contactsView.searchConttroller.searchResultsUpdater = self
        contactsView.tableView.delegate = self
        contactsView.tableView.dataSource = self
        viewModel.delegate = self
        
        contactsView.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: idCell.idContactsCell.rawValue)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        contactsView.segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        
        contactsView.setConstraints()
        setupLayout()
    }
    @objc private func segmentedChange(){
        applySegmentedFilter()
    }
    
    @objc func addButtonTapped(){
        let contactOption = OptionsContactsViewController2() // OptionsContactsTableViewController
        navigationController?.pushViewController(contactOption, animated: true)
    }
    
    func fetchContactsOptions(){
        model.fetchContactsOptions()
        updateContactsTableView()
    }
    
    func deleteContact(at indexPath: IndexPath){
        model.deleteContacts(at: indexPath)
        contactsView.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    func applySegmentedFilter(){
        guard let selectedSegmentTitle = contactsView.segmentedControl.titleForSegment(at: contactsView.segmentedControl.selectedSegmentIndex) else {return}
        viewModel.applySegmentedFilter(selectedSegmentTitle: selectedSegmentTitle, isFiltred: contactsView.isFiltred)
        updateContactsTableView()
    }
    
    private func setupLayout() {
        view.addSubview(contactsView)
        NSLayoutConstraint.activate([
            contactsView.topAnchor.constraint(equalTo: view.topAnchor),
            contactsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contactsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
}

extension ContactsViewController2: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print((contactsView.isFiltred ? model.countFilteredModel() : model.countModel()))
        
        return (contactsView.isFiltred ? model.countFilteredModel() : model.countModel())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idContactsCell.rawValue, for: indexPath) as! ContactsTableViewCell
        if let modelContacts = (contactsView.isFiltred ? model.getFilteredModel(indexPath: indexPath) : model.getModel(indexPath: indexPath)) {
        cell.configure(model: modelContacts)
        }
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
            self?.deleteContact(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

extension ContactsViewController2: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterContentForSearchText(contactsView.searchConttroller.searchBar.text!, segmentedControl: contactsView.segmentedControl, isFiltred: contactsView.isFiltred)
        updateContactsTableView()
    }
}

extension ContactsViewController2: ContactsViewModelDelegate {
    func updateContactsTableView() {
        DispatchQueue.main.async {
            self.contactsView.tableView.reloadData()
        }
        
    }
}
