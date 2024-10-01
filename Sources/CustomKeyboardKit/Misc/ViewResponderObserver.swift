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
    var cancellables: Set<AnyCancellable> = .init()
    
    var view: UIView? {
        didSet {
            observeFirstResponder()
        }
    }
    
    func observeFirstResponder() {
        cancellables.removeAll()
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.keyboardWillShow(notification)
            }
            .store(in: &cancellables)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] notification in
                self?.keyboardWillHide(notification)
            }
            .store(in: &cancellables)
        NotificationCenter.default.publisher(for: .viewDidBecomeFirstResponder)
            .sink { [weak self] notification in
                self?.viewDidBecomeFirstResponder(notification)
            }
            .store(in: &cancellables)
    }

    func keyboardWillShow(_ notification: Notification) {
        if !isFirstResponder && view?.isFirstResponder == true {
            isFirstResponder = true
            NotificationCenter.default.post(name: .viewDidBecomeFirstResponder, object: nil, userInfo: [Notification.keyboardObserverIdKey : id ])
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if isFirstResponder {
            isFirstResponder = false
        }
    }

    func viewDidBecomeFirstResponder(_ notification: Notification) {
        if isFirstResponder && notification.viewResponderObserverId != id {
            isFirstResponder = false
        }
    }
}
