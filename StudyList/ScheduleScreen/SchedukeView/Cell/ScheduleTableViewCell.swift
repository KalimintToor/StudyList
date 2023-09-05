//
//  ScheduleTableViewCell.swift
//  StudyList
//
//  Created by Александр on 7/30/23.
//

import UIKit
import CoreData

class ScheduleTableViewCell: UITableViewCell {
    
    var lessonNameLabel = UILabel(text: "", font: .avenirNext20())
    
    let teacherNameLabel = UILabel(text: "", font: .avenirNext20(), alignment: .right)
    
    let lessonTimeLabel = UILabel(text: "08:30", font: .avenirNext20())
    
    let typeLabel = UILabel(text: "Type is:", font: .avenirNext20(), alignment: .right)
    
    let lessonTypeLabel = UILabel(text: "", font: .avenirNextDemiBold20())
    
    let buildingLabel = UILabel(text: "Corpus:", font: .avenirNext20(), alignment: .right)
    
    let lessonBuildingLabel = UILabel(text: "", font: .avenirNextDemiBold20())
    
    let audLabel = UILabel(text: "Auditoring:", font: .avenirNext20(), alignment: .right)
    
    let lessonAudLabel = UILabel(text: "", font: .avenirNextDemiBold20())
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        self.selectionStyle = .none //отключение выбора ячейки
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: ScheduleModel){
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        lessonNameLabel.text = model.nameLesson
        typeLabel.text = model.typeLesson
        lessonTimeLabel.text = dateFormater.string(from: model.timeNumbers ?? Date())
        lessonBuildingLabel.text = model.buildNumber
        lessonAudLabel.text = model.audienceNumber
        teacherNameLabel.text = model.teacherName
        
        backgroundColor = UIColor().hexStringToUIColor(hex: model.colorType!)
    }
    
    func setConstraints(){
        
        let topStackView = UIStackView(arrangedSubviews: [lessonNameLabel, teacherNameLabel],
                                    axis: .horizontal,
                                    spacing: 10,
                                    distribution: .fillEqually)
        
        self.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            topStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.addSubview(lessonTimeLabel)
        NSLayoutConstraint.activate([
            lessonTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lessonTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            lessonTimeLabel.widthAnchor.constraint(equalToConstant: 100),
            lessonTimeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let bottomStackView = UIStackView(arrangedSubviews: [typeLabel, lessonTypeLabel, buildingLabel, lessonBuildingLabel, audLabel, lessonAudLabel],
                                    axis: .horizontal,
                                    spacing: 5,
                                    distribution: .fillProportionally)
        
        self.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            bottomStackView.leadingAnchor.constraint(equalTo: lessonTimeLabel.trailingAnchor, constant: 5),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            bottomStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
