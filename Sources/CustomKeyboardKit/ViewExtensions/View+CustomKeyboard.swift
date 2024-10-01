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
    @StateObject var editStateObserver = ViewEditingStateObserver()
    
    public init(keyboardType: CustomKeyboard) {
        self.keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(editStateObserver.$isEditing) { isEditing in
                assignCustomSubmitToKeyboardForEditingView(isEditing: isEditing)
            }
            .introspect(.textEditor, on: .iOS(.v15...)) { uiTextView in
                uiTextView.inputView = keyboardType.keyboardInputView
                editStateObserver.view = uiTextView
                recoverCustomKeyboardViewIfNeeded(for: uiTextView)
            }
            .introspect(.textField, on: .iOS(.v15...)) { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
                editStateObserver.view = uiTextField
                recoverCustomKeyboardViewIfNeeded(for: uiTextField)
            }
    }
    
    func assignCustomSubmitToKeyboardForEditingView(isEditing: Bool) {
        if isEditing {
            keyboardType.onSubmit = onCustomSubmit
        }
    }
    
    func recoverCustomKeyboardViewIfNeeded(for view: UIView?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if view?.isFirstResponder == true && !keyboardType.keyboardInputView.isVisible {
                editStateObserver.view?.resignFirstResponder()
                editStateObserver.view?.becomeFirstResponder()
            }
        }
    }
}
