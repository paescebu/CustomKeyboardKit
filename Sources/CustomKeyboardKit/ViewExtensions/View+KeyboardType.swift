//
//  CustomKeyboardModifier.swift
//  
//
//  Created by PascalBurlet on 30.06.22.
//

import Foundation
import UIKit
import SwiftUI
import Combine
@_spi(Advanced) import SwiftUIIntrospect

public extension View {
    @available(*, deprecated, message: "Use the keyboardType(_:) overload instead.")
    func customKeyboard(view: @escaping (UITextDocumentProxy, @escaping CustomKeyboard.SubmitHandler, CustomKeyboard.SystemFeedbackHandler?) -> some View) -> some View {
        customKeyboard(CustomKeyboard(customKeyboardView: view))
    }
    
    func keyboardType(view: @escaping (UITextDocumentProxy, @escaping CustomKeyboard.SubmitHandler, CustomKeyboard.SystemFeedbackHandler?) -> some View) -> some View {
        customKeyboard(CustomKeyboard(customKeyboardView: view))
    }
}


public extension View {
    @available(*, deprecated, message: "Use the keyboardType(_:) overload instead.")
    func customKeyboard(_ keyboardType: Keyboard) -> some View {
        self
            .modifier(KeyboardModifier(keyboardType: keyboardType))
    }
}

public extension View {
    func keyboardType(_ keyboardType: Keyboard) -> some View {
        self
            .modifier(KeyboardModifier(keyboardType: keyboardType))
    }
}

public struct KeyboardModifier: ViewModifier {
    var keyboardType: Keyboard
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var textViewObserver = ActiveTextViewObserver()
    
    public init(keyboardType: Keyboard) {
        self.keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(textViewObserver.$isEditing, perform: assignSubmitForEditingView)
            .onChange(of: textViewObserver.textView, perform: recoverCustomKeyboardIfNeeded)
            .onChange(of: keyboardType) { newKeyboard in
                switchKeyboard(to: newKeyboard, on: textViewObserver.textView)
                textViewObserver.textView?.reloadInputViews()
            }
            .introspect(.textEditor, on: .iOS(.v15...)) { uiTextView in
                switchKeyboard(to: keyboardType, on: uiTextView)
                textViewObserver.set(textView: uiTextView)
            }
            .introspect(.textField, on: .iOS(.v15...)) { uiTextField in
                switchKeyboard(to: keyboardType, on: uiTextField)
                textViewObserver.set(textView: uiTextField)
            }
    }
    
    private func switchKeyboard(to keyboard: Keyboard, on textView: (any TextEditing)?) {
        switch keyboard {
        case let systemKeyboard as SystemKeyboard:
            textView?.inputView = nil
            textView?.keyboardType = systemKeyboard.keyboardType
        case let customKeyboard as Keyboard:
            textView?.inputView = customKeyboard.keyboardInputView
        default:
            textView?.inputView = nil
        }
    }
    
    func assignSubmitForEditingView(isEditing: Bool) {
        if isEditing {
            keyboardType.onSubmit = onCustomSubmit
        }
    }
    
    func recoverCustomKeyboardIfNeeded(for view: UIView?) {
        guard let view else { return }
        
        if view.isFirstResponder && !keyboardType.view.isVisible {
            view.resignFirstResponder()
            view.becomeFirstResponder()
        }
    }
}
