//
//  ViewResponderObserver.swift
//  CustomKeyboardKit
//
//  Created by Pascal Burlet on 29.09.2024.
//

import UIKit
import Combine

fileprivate extension Notification.Name {
    static let viewDidBecomeFirstResponder = Notification.Name("CustomKeyboardKit.viewDidBecomeFirstResponder")
}

@MainActor
class ViewResponderObserver: NSObject, ObservableObject, UITextFieldDelegate, UITextViewDelegate, Identifiable {
    static let keyboardObserverIdKey = "keyboardObserverIdKey"
    @Published var isFirstResponder: Bool = false
    
    var view: UIView? {
        didSet {
            observeFirstResponder()
        }
    }
    
    func observeFirstResponder() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeFirstResponder(_:)), name: .viewDidBecomeFirstResponder, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if view?.isFirstResponder == true {
            if !isFirstResponder {
                isFirstResponder = true
                NotificationCenter.default.post(name: .viewDidBecomeFirstResponder, object: nil, userInfo: [Self.keyboardObserverIdKey : id ])
            }
        }
    }

    @objc func viewDidBecomeFirstResponder(_ notification: Notification) {
        let objectId = notification.userInfo?[Self.keyboardObserverIdKey] as? ObjectIdentifier
        if objectId != id {
            isFirstResponder = false
        }
    }
}
