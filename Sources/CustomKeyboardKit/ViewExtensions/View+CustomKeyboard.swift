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
    func customKeyboard(view: @escaping (UITextDocumentProxy, CustomKeyboardBuilder.SubmitHandler, CustomKeyboardBuilder.SystemFeedbackHandler?) -> some View) -> some View {
        customKeyboard(CustomKeyboardBuilder(customKeyboardView: view))
    }
}

public extension View {
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifier(keyboardType: keyboardType))
    }
}

public struct CustomKeyboardModifier: ViewModifier {
    let keyboardType: CustomKeyboard
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var textViewObserver = ActiveTextViewObserver()
    
    public init(keyboardType: CustomKeyboard) {
        self.keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(textViewObserver.$isEditing) { isEditing in
                assignSubmitForEditingView(isEditing: isEditing)
            }
            .onChange(of: textViewObserver.textView) { textView in
                recoverCustomKeyboardIfNeeded(for: textView)
            }
            .introspect(.textEditor, on: .iOS(.v15...)) { uiTextView in
                uiTextView.inputView = keyboardType.keyboardInputView
                textViewObserver.set(textView: uiTextView)
            }
            .introspect(.textField, on: .iOS(.v15...)) { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
                textViewObserver.set(textView: uiTextField)
            }
    }
    
    func assignSubmitForEditingView(isEditing: Bool) {
        if isEditing {
            keyboardType.onSubmit = onCustomSubmit
        }
    }
    
    func recoverCustomKeyboardIfNeeded(for view: UIView?) {
        guard let view else { return }
        
        if view.isFirstResponder && !keyboardType.keyboardInputView.isVisible {
            view.resignFirstResponder()
            view.becomeFirstResponder()
        }
    }
}
