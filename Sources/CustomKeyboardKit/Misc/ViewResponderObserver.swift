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

fileprivate extension Notification {
    static let keyboardObserverIdKey = "keyboardObserverIdKey"

    @MainActor
    var viewResponderObserverId: ObjectIdentifier? {
        userInfo?[Self.keyboardObserverIdKey] as? ObjectIdentifier
    }
}

@MainActor
class ViewResponderObserver: NSObject, ObservableObject, UITextFieldDelegate, UITextViewDelegate, Identifiable {
    @Published var isFirstResponder: Bool = false
    
    var view: UIView? {
        didSet {
            observeFirstResponder()
        }
    }
    
    func observeFirstResponder() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeFirstResponder(_:)), name: .viewDidBecomeFirstResponder, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if view?.isFirstResponder == true {
            if !isFirstResponder {
                isFirstResponder = true
                NotificationCenter.default.post(name: .viewDidBecomeFirstResponder, object: nil, userInfo: [Notification.keyboardObserverIdKey : id ])
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if isFirstResponder {
            isFirstResponder = false
        }
    }

    @objc func viewDidBecomeFirstResponder(_ notification: Notification) {
        if notification.viewResponderObserverId != id {
            isFirstResponder = false
        }
    }
}
