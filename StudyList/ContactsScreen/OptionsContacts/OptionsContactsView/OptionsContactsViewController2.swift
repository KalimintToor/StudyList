//
//  OptionsContactsViewController2.swift
//  StudyList
//
//  Created by Александр on 9/3/23.
//

import UIKit
import CoreData

class OptionsContactsViewController2: UITableViewController {
    
    var optionsContactsViewModel:  OptionsContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Optional Schedule"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        optionsContactsViewModel = OptionsContactsViewModel()
        optionsContactsViewModel.delegate = self
        
        tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(OptionsViewCell.self, forCellReuseIdentifier: idCell.idContactsScheduleCell.rawValue)
        tableView.register(HeaderOptionTabelViewCell.self, forHeaderFooterViewReuseIdentifier: idCell.idContactsHeader.rawValue)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func saveButtonTapped(){
        optionsContactsViewModel.saveButtonTapped()
        tableView.reloadData()
    }
}
extension OptionsContactsViewController2 {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell.idContactsScheduleCell.rawValue, for: indexPath) as! OptionsViewCell
        cell.cellContactsConfigure(nameArray: optionsContactsViewModel.model.cellNameArray, indexPath: indexPath, imageName: optionsContactsViewModel.model.defImageContacts)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 4 ? 200 : 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idCell.idContactsHeader.rawValue) as! HeaderOptionTabelViewCell
        header.headerConfigure(nameArray: optionsContactsViewModel.model.headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! OptionsViewCell
        
        switch indexPath.section {
        case 0: alertForCellName(label: cell.nameCellLabel, name: "Name Contact", placeholder: "Enter name contact") { (text) in
            self.optionsContactsViewModel.model.nameContacts = text
        }
        case 1: alertForCellName(label: cell.nameCellLabel, name: "Phone Contact", placeholder: "Enter phone contact") { (text) in
            
            self.optionsContactsViewModel.model.phoneContacts = text
        }
        case 2: alertForCellName(label: cell.nameCellLabel, name: "Mail Contact", placeholder: "Enter mail contact") { (text) in
            
            self.optionsContactsViewModel.model.mailContacts = text
        }
        case 3: alertFriendOrTeacher(label: cell.nameCellLabel) { (type) in
            self.optionsContactsViewModel.model.typeContacts = type
        }
        case 4: alertPhotoCamera { (source) in
            self.chooseImagePicker(source: source)
        }
        default:
            print("tap on cell")
        }
    }
    
    func pushControllers(viewController: UIViewController){
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OptionsContactsViewController2: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let cell = tableView.cellForRow(at: [4, 0]) as! OptionsViewCell
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        optionsContactsViewModel.model.imageContacts = (info[.editedImage] as? UIImage)?.jpegData(compressionQuality: 1.0)
        dismiss(animated: true)
    }
}

extension OptionsContactsViewController2: OptionsScheduleViewModelDelegate{
    func viewModelDidShowAlert(title: String, message: String?) {
        alertOkey(title: title, message: message)
    }
    
    func viewModelDidRequestPush(viewController: UIViewController) {
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
