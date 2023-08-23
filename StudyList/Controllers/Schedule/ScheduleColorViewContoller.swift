//
//  ScheduleColorViewContoller.swift
//  StudyList
//
//  Created by Александр on 7/31/23.
//

import UIKit

class ScheduleColorViewContoller: UITableViewController {
    
    
    
    let idOptionsColorCell = "idOptionsColorCell"
    let idOptionsHeader = "idOptionsHeader"
    
    let headerNameArray = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "DEEP BLUE", "PURPLE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: idOptionsColorCell)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsHeader)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsColorCell, for: indexPath) as! ColorTableViewCell
        cell.cellConfigure(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsHeader) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap cell")
        switch indexPath.section {
        case 0: setColor(color: "BE2813")
        case 1: setColor(color: "B97A19")
        case 2: setColor(color: "467C24")
        case 3: setColor(color: "F5B433")
        case 4: setColor(color: "3DACF7")
        case 5: setColor(color: "2D038F")
        case 6: setColor(color: "E87AA4")
            
        default:
            setColor(color: "FFFFFF")
        }
    }
    
    private func setColor(color: String){
        let scheduleOptions = self.navigationController?.viewControllers[1] as? OptionsScheduleTableViewController
        scheduleOptions?.hexColorCell = color
        scheduleOptions?.tableView.reloadRows(at: [[3, 0], [4, 0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
