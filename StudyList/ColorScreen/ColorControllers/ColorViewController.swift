//
//  ColorViewController.swift
//  StudyList
//
//  Created by Александр on 9/3/23.
//

import UIKit

class ColorViewController2: UITableViewController {
    
    private let model = ColorModel()
    weak var delegate: ColorSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: idCell.idOptionsColorCell.rawValue)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idCell.idOptionsHeader.rawValue)
    }
}

extension ColorViewController2 {
    override func numberOfSections(in tableView: UITableView) -> Int {
        model.headerNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idOptionsColorCell.rawValue, for: indexPath) as! ColorTableViewCell
        cell.cellConfigure(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idCell.idOptionsHeader.rawValue) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: model.headerNameArray, section: section)
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
        case 2: setColor(color: "F5B433")
        case 3: setColor(color: "467C24")
        case 4: setColor(color: "3DACF7")
        case 5: setColor(color: "2D038F")
        case 6: setColor(color: "E87AA4")
            
        default:
            setColor(color: "FFFFFF")
        }
    }
    
    private func setColor(color: String) {
        delegate?.didSelectColor(color: color)
        self.navigationController?.popViewController(animated: true)
    }

    
    func pushTasksControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

