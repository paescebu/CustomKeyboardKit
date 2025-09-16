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
        customKeyboard(CustomKeyboardBuilder(customKeyboardView: view))
    }
}


public extension View {
    @available(*, deprecated, message: "Use keyboardType(_:) overload instead.")
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifier(keyboardType: keyboardType))
    }
}

public extension View {
    func keyboardType(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifier(keyboardType: keyboardType))
    }
}

public extension CustomKeyboard {
    static func system(_ keyboardType: UIKeyboardType) -> CustomKeyboard {
        SystemKeyboard(keyboardType: keyboardType)
    }
}

public class SystemKeyboard: CustomKeyboard {
    let keyboardType: UIKeyboardType
    
    init(keyboardType: UIKeyboardType) {
        self.keyboardType = keyboardType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public struct CustomKeyboardModifier: ViewModifier {
    var keyboardType: CustomKeyboard
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var textViewObserver = ActiveTextViewObserver()
    
    public init(keyboardType: CustomKeyboard) {
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
    
    private func switchKeyboard(to keyboard: CustomKeyboard?, on textView: (any TextEditing)?) {
        switch keyboard {
        case let systemKeyboard as SystemKeyboard:
            textView?.inputView = nil
            textView?.keyboardType = systemKeyboard.keyboardType
        case let customKeyboard as CustomKeyboard:
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
