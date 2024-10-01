//
//  ViewEditingStateObserver.swift
//  CustomKeyboardKit
//
//  Created by Pascal Burlet on 29.09.2024.
//

import UIKit
import Combine

@MainActor
class ViewEditingStateObserver: NSObject, ObservableObject, Identifiable {
    @Published var isEditing: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    var view: UIView? {
        didSet {
            cancellables.removeAll()
            observeEditingStateForTextField(for: view)
            observeEditingStateForTextView(for: view)
        }
    }

    private func observeEditingStateForTextField(for view: UIView?) {
        if let textField = view as? UITextField {
            let didBeginEditingPublisher = NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification, object: textField)
            let didEndEditingPublisher = NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification, object: textField)
            
            didBeginEditingPublisher
                .sink { [weak self] _ in
                    self?.isEditing = true
                }
                .store(in: &cancellables)

            didEndEditingPublisher
                .sink { [weak self] _ in
                    self?.isEditing = false
                }
                .store(in: &cancellables)
        }
    }
    
    private func observeEditingStateForTextView(for view: UIView?) {
        if let textView = view as? UITextView {
            let didBeginEditingPublisher = NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: textView)
            let didEndEditingPublisher = NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: textView)
            
            didBeginEditingPublisher
                .sink { [weak self] _ in
                    self?.isEditing = true
                }
                .store(in: &cancellables)

            didEndEditingPublisher
                .sink { [weak self] _ in
                    self?.isEditing = false
                }
                .store(in: &cancellables)
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
