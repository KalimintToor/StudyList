//
//  AlertFriendsOrTeacher.swift
//  StudyList
//
//  Created by Александр on 8/2/23.
//

import UIKit

extension UIViewController {
    func alertFriendOrTeacher(label: UILabel, complitionHandler: @escaping (String) -> Void){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let friend = UIAlertAction(title: "Friend", style: .default) { _ in
            label.text = "Friend"
            let typeContact = "Friend"
            complitionHandler(typeContact)
        }
        
        let teacher = UIAlertAction(title: "Teacher", style: .default) { _ in
            label.text = "Teacher"
            let typeContact = "Teacher"
            complitionHandler(typeContact)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(friend)
        alertController.addAction(teacher)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
