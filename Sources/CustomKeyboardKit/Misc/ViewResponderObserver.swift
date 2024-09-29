//
//  ViewResponderObserver.swift
//  CustomKeyboardKit
//
//  Created by Pascal Burlet on 29.09.2024.
//

import UIKit
import Combine

@MainActor
class ViewResponderObserver: NSObject, ObservableObject, UITextFieldDelegate, UITextViewDelegate {
    @Published var isFirstResponder: Bool = false

    var view: UIView? {
        didSet {
            (view as? UITextField)?.delegate = self
            (view as? UITextView)?.delegate = self
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isFirstResponder = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isFirstResponder = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isFirstResponder = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isFirstResponder = false
    }
}
