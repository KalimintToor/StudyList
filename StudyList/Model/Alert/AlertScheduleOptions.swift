//
//  AlertScheduleOptions.swift
//  StudyList
//
//  Created by Александр on 8/10/23.
//


import UIKit
import CoreData

extension UIViewController{
    func alertScheduleOptions(label: UILabel, name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textFieldAlert) in
            textFieldAlert.placeholder = placeholder
        }
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textFieldAlert = alert.textFields?.first
            guard let text = textFieldAlert?.text else {return}
            label.text = (text != "" ? text : label.text)
            completionHandler(text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
