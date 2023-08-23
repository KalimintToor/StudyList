//
//  OptionsTableViewCell.swift
//  StudyList
//
//  Created by Александр on 8/12/23.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    let backgroundViewCell: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameCellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repeatingSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = true
        repeatSwitch.isHidden = true
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    weak var switchRepeatDelegate: SwithRepeatProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        repeatingSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellScheduleConfigure(nameArray: [[String]], indexPath: IndexPath, hexColor: String, nameTeacher: String){
        nameCellLabel.text = nameArray[indexPath.section][indexPath.row]
        repeatingSwitch.isHidden = (indexPath.section == 4 ? false : true)

        if indexPath.section == 2 {
            nameCellLabel.text = nameTeacher
        }

        let color = UIColor().hexStringToUIColor(hex: hexColor)
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? color : .white)
        repeatingSwitch.onTintColor = UIColor().hexStringToUIColor(hex: hexColor)
    }
    
    @objc func switchChange(paramTarget: UISwitch){
        switchRepeatDelegate?.switchrepeat(value: paramTarget.isOn)
    }
    
    func cellTasksConfigure(nameArray: [String], indexPath: IndexPath, hexColor: String){
        nameCellLabel.text = nameArray[indexPath.section]
        
        let color = UIColor().hexStringToUIColor(hex: hexColor)
        backgroundViewCell.backgroundColor = (indexPath.section == 3 ? color : .white)
        repeatingSwitch.onTintColor = UIColor().hexStringToUIColor(hex: hexColor)
    }
    
    func cellContactsConfigure(nameArray: [String], indexPath: IndexPath){
        nameCellLabel.text = nameArray[indexPath.section]
    }
    
    
    func setConstraints(){
        self.contentView.addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        ])
        
        self.addSubview(nameCellLabel)
        NSLayoutConstraint.activate([
            nameCellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCellLabel.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 15)
        ])
        
        self.contentView.addSubview(repeatingSwitch)
        NSLayoutConstraint.activate([
            repeatingSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repeatingSwitch.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -20)
        ])
        
    }
}
