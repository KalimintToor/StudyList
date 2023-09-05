//
//  AlertOkey.swift
//  StudyList
//
//  Created by Александр on 8/11/23.
//

import UIKit
import CoreData

extension UIViewController{
    func alertOkey(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
}
