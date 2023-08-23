//
//  PressButtonProtocols.swift
//  StudyList
//
//  Created by Александр on 7/30/23.
//

import Foundation

protocol TaskReadyDelegate: class {
    func taskReadyDidChange(newTaskReady: Bool)
}

protocol SwithRepeatProtocol: class {
    func switchrepeat(value: Bool)
}
