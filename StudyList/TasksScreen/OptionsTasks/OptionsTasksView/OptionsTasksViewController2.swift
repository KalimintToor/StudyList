//
//  OptionsTasksViewController2.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import UIKit
import CoreData

class OptionsTasksViewController2: UITableViewController {
    
    var optionsTasksViewModel = OptionsTasksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        optionsTasksViewModel.delegate = self
        
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(OptionsViewCell.self, forCellReuseIdentifier: idCell.idOptionsTasksCell.rawValue)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idCell.idOptionsHeader.rawValue)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func saveButtonTapped(){
        optionsTasksViewModel.saveButtonTapped()
    }
}

extension OptionsTasksViewController2 {
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idOptionsTasksCell.rawValue, for: indexPath) as! OptionsViewCell
        cell.cellTasksConfigure(nameArray: optionsTasksViewModel.model.cellNameArray, indexPath: indexPath, hexColor: optionsTasksViewModel.model.hexColorCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idCell.idOptionsHeader.rawValue) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: optionsTasksViewModel.model.headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsViewCell
        
        switch indexPath.section {
        case 0: alertDate(label: cell.nameCellLabel) { (weekDay, date)  in
            self.optionsTasksViewModel.model.dateTasks = date
//            print(self.model.dateTasks)
        }
        case 1: alertForCellName(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { text in
            self.optionsTasksViewModel.model.nameLessonType = text
        }
        case 2: alertForCellName(label: cell.nameCellLabel, name: "Name Task", placeholder: "Enter name task") { (text) in
            self.optionsTasksViewModel.model.tasksName = text
        }
        case 3: selectColor() //optionsTasksViewModel.pushControllers(viewController: ColorViewController2())
        default:
            print("no signal")
        }
    }
    
    func selectColor() {
        let colorVC = ColorViewController2()
        colorVC.delegate = self
        navigationController?.pushViewController(colorVC, animated: true)
    }
}

extension OptionsTasksViewController2: ColorSelectionDelegate {
    func didSelectColor(color: String) {
        optionsTasksViewModel.model.hexColorCell = color
        tableView.reloadData()
    }
}


extension OptionsTasksViewController2: OptionsScheduleViewModelDelegate{
    func viewModelDidShowAlert(title: String, message: String?) {
        alertOkey(title: title, message: message)
    }
    
    func viewModelDidRequestPush(viewController: UIViewController) {
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
