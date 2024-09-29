//
//  CustomKeyboardModifier.swift
//  
//
//  Created by PascalBurlet on 30.06.22.
//

import Foundation
import UIKit
import SwiftUI
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
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var keyboardType: CustomKeyboard
    
    public init(keyboardType: CustomKeyboard) {
        self._keyboardType = StateObject(wrappedValue: keyboardType)
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                keyboardType.onSubmit = onCustomSubmit
            }
            .introspect(.textEditor, on: .iOS(.v15...)) { uiTextView in
                uiTextView.inputView = keyboardType.keyboardInputView

                recoverCustomInputViewIfNeeded(for: uiTextView)
            }
            .introspect(.textField, on: .iOS(.v15...)) { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
                recoverCustomInputViewIfNeeded(for: uiTextField)
            }
    }
    
    func recoverCustomInputViewIfNeeded(for view: UIView) {
        if view.isFirstResponder && !keyboardType.keyboardInputView.isVisible {
            DispatchQueue.main.async {
                view.resignFirstResponder()
                view.becomeFirstResponder()
            }
        }
    }
}
