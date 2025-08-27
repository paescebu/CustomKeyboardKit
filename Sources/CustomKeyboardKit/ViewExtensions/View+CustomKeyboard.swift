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
    func customKeyboard(view: @escaping (UITextDocumentProxy, @escaping CustomKeyboardBuilder.SubmitHandler, CustomKeyboardBuilder.SystemFeedbackHandler?) -> some View) -> some View {
        customKeyboard(.constant(CustomKeyboardBuilder(customKeyboardView: view)))
    }
}

public extension View {
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomDynamicKeyboardModifier(keyboardType: .constant(keyboardType)))
    }
    
    func customKeyboard(_ keyboardType: Binding<CustomKeyboard>) -> some View {
        self
            .modifier(CustomDynamicKeyboardModifier(keyboardType: keyboardType))
    }
}

public struct CustomDynamicKeyboardModifier: ViewModifier {
    @Binding var keyboardType: CustomKeyboard
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var textViewObserver = ActiveTextViewObserver()

    public init(keyboardType: Binding<CustomKeyboard>) {
        self._keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(textViewObserver.$isEditing, perform: assignSubmitForEditingView)
            .onChange(of: textViewObserver.textView, perform: recoverCustomKeyboardIfNeeded)
            .onChange(of: keyboardType) { newValue in
                textViewObserver.textView?.inputView = newValue.keyboardInputView
                textViewObserver.textView?.reloadInputViews()
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
    
    func recoverCustomKeyboardIfNeeded(for view: UIResponder?) {
        guard let view else { return }
        
        if view.isFirstResponder && !keyboardType.keyboardInputView.isVisible {
            view.resignFirstResponder()
            view.becomeFirstResponder()
        }
    }
}
