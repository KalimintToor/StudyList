//
//  HeaderOptionTabelViewCell.swift
//  StudyList
//
//  Created by Александр on 8/12/23.
//

import UIKit

class HeaderOptionTabelViewCell: UITableViewHeaderFooterView {
    let headerLabel = UILabel(text: "", font: UIFont(name: "Avenir Next", size: 14))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        headerLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
//        self.backgroundColor = .clear
        setConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headerConfigure(nameArray: [String], section: Int){
        headerLabel.text = nameArray[section]
    }
    
    func setConstraint(){
        self.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
}
