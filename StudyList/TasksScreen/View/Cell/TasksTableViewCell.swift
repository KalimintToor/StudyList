//
//  TasksTableViewCell.swift
//  StudyList
//
//  Created by Александр on 7/30/23.
//

import UIKit
import CoreData

class TasksTableViewCell: UITableViewCell {
    
    var objectID: NSManagedObjectID?
    weak var cellTaskDelegate: TaskReadyDelegate?
    var managedObjectContext: NSManagedObjectContext?
    
    let taskNameLabel = UILabel(text: "Programming", font: .avenirNextDemiBold20())
    let taskDescription = UILabel(text: "Writing Extension", font: .avenirNext20())
    
    let readyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected) // задаем картинку для состояния .selected
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        self.selectionStyle = .none //отключение выбора ячейки
        taskDescription.numberOfLines = 2
        
        readyButton.addTarget(self, action: #selector(readyButtonTaped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(taskItem: TasksScreenModel) {
        taskNameLabel.text = taskItem.task.lessonName
        taskDescription.text = taskItem.task.tasksName
        readyButton.isSelected = taskItem.task.taskReady
        
        self.objectID = taskItem.task.objectID
        
        backgroundColor = UIColor().hexStringToUIColor(hex: taskItem.task.colorType ?? "FFFFFF")
    }

    
    @objc func readyButtonTaped(){
        readyButton.isSelected.toggle()
        guard let taskID = objectID, let delegate = cellTaskDelegate else { return }
        delegate.taskReadyDidChange(objectID: taskID, newValue: readyButton.isSelected)
        print(readyButton.isSelected)
        
    }
    
    func setConstraints(){
        
        self.contentView.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            readyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 40),
            readyButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(taskNameLabel)
        NSLayoutConstraint.activate([
            taskNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            taskNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskNameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        self.addSubview(taskDescription)
        NSLayoutConstraint.activate([
            taskDescription.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 5),
            taskDescription.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
