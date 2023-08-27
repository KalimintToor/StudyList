//
//  ContactsTableViewCell.swift
//  StudyList
//
//  Created by Александр on 8/2/23.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    let contactImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.fill"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true //обрезка ненужных краев
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let phoneImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "phone.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let mailImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "envelope.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel = UILabel(text: "", font: UIFont(name: "Avenir Next", size: 14))
    let phoneLabel = UILabel(text: "", font: UIFont(name: "Avenir Next", size: 14))
    let mailLabel = UILabel(text: "", font: UIFont(name: "Avenir Next", size: 14))
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        contactImageView.layer.cornerRadius = contactImageView.frame.height / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        self.selectionStyle = .none //отключение выбора ячейки
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Contacts){
        
        nameLabel.text = model.contactsName
        phoneLabel.text = model.contactsPhone
        mailLabel.text = model.contactsMail
        
        if let data = model.contactsImage, let image = UIImage(data: data){
            contactImageView.image = image
        }else {
            contactImageView.image = UIImage(systemName: "person.fill")
        }
        
    }
    
    func setConstraints(){
        
        self.addSubview(contactImageView)
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contactImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            contactImageView.widthAnchor.constraint(equalToConstant: 70),
            contactImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [phoneLabel, phoneImageView, mailImageView, mailLabel], axis: .horizontal, spacing: 3, distribution: .fillProportionally)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
}

