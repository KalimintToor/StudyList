//
//  AlertForCellName.swift
//  StudyList
//
//  Created by Александр on 7/31/23.
//

import UIKit

extension UIViewController {
    
    func alertForCellName(label: UILabel, name: String, placeholder: String, completionHandler: @escaping (String) -> Void){
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textFieldAlert = alert.textFields?.first
            guard let text = textFieldAlert?.text else {return}
            
            label.text = (text != "" ? text : label.text)
            completionHandler(text)
        }
        
        alert.addTextField { (textFieldAlert) in
            textFieldAlert.placeholder = placeholder
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}


