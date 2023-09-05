//
//  OptionsScheduleViewController2.swift
//  StudyList
//
//  Created by Александр on 8/29/23.
//

import UIKit
import CoreData

class OptionsScheduleViewController2: UITableViewController {
    
    let optionsScheduleViewModel: OptionsScheduleViewModel = OptionsScheduleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        optionsScheduleViewModel.delegate = self
        
        tableView.register(OptionsViewCell.self, forCellReuseIdentifier: idCell.idOptionsScheduleCell.rawValue)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier:  idCell.idOptionsHeader.rawValue)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
    }
    
    @objc private func saveButtonTapped(){
        optionsScheduleViewModel.saveButtonTapped()
        tableView.reloadData()
    }
    
    private func fetchData(){
        optionsScheduleViewModel.fetch()
    }
    
    
}

extension OptionsScheduleViewController2 {
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 4
        case 2: return 1
        case 3: return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idOptionsScheduleCell.rawValue, for: indexPath) as! OptionsViewCell
        cell.switchRepeatDelegate = self
//        cell.switchRepeatDelegate = optionsScheduleViewModel.switchrepeat(value: model.repeatSwitch ?? true)
        cell.cellScheduleConfigure(nameArray: optionsScheduleViewModel.model.cellNameArray,
                                   indexPath: indexPath,
                                   hexColor: optionsScheduleViewModel.model.hexColorCell,
                                   nameTeacher: optionsScheduleViewModel.model.teacherName ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idCell.idOptionsHeader.rawValue) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: optionsScheduleViewModel.model.headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsViewCell
        
        switch indexPath {
        case [0, 0]: alertDate(label: cell.nameCellLabel) { (numberWeekDay, date) in
            self.optionsScheduleViewModel.model.dateNum = date
            self.optionsScheduleViewModel.model.weekDays = Int16(numberWeekDay)
            
        }
        case [0, 1]: alertTime(label: cell.nameCellLabel) { (time) in
            self.optionsScheduleViewModel.model.timeNum = time
        }
        case [1, 0]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { text in
                self.optionsScheduleViewModel.model.nameLessonType = text
            }
        case [1, 1]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Type Lesson", placeholder: "Enter type lesson") { text in
                self.optionsScheduleViewModel.model.typeLessonType = text
            }
        case [1, 2]:
            alertScheduleOptions(label: cell.nameCellLabel, name: "Building number", placeholder: "Enter number of building") { text in
                self.optionsScheduleViewModel.model.buildNumbers = text
            }
        case [1, 3]: alertScheduleOptions(label: cell.nameCellLabel, name: "Audience number", placeholder: "Enter number of audience") { text in
            self.optionsScheduleViewModel.model.audienceNumber = text
        }
            
        case [2, 0]:
            optionsScheduleViewModel.pushControllers(viewController: TeachersViewController2())
        case [3, 0]:
            selectColor()//optionsScheduleViewModel.pushControllers(viewController: ScheduleColorViewContoller())
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

extension OptionsScheduleViewController2: ColorSelectionDelegate {
    func didSelectColor(color: String) {
        optionsScheduleViewModel.model.hexColorCell = color
        tableView.reloadRows(at: [[3, 0], [4, 0]], with: .none)
    }
}

extension OptionsScheduleViewController2: SwithRepeatProtocol{
    func switchrepeat(value: Bool) {
        optionsScheduleViewModel.switchrepeat(value: value)
    }
}

extension OptionsScheduleViewController2: OptionsScheduleViewModelDelegate{
    func viewModelDidShowAlert(title: String, message: String?) {
        alertOkey(title: title, message: message)
    }
    
    func viewModelDidRequestPush(viewController: UIViewController) {
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
