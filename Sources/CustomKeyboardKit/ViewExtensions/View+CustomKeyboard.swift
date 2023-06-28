//
//  CustomKeyboardModifier.swift
//  
//
//  Created by PascalBurlet on 30.06.22.
//

import Foundation
import UIKit
import SwiftUI
import SwiftUIIntrospect

public extension TextField {
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifierTextField(keyboardType: keyboardType))
    }
}

public extension TextEditor {
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifierTextEditor(keyboardType: keyboardType))
    }
}

public struct CustomKeyboardModifierTextEditor: ViewModifier {
    @Environment(\.onSubmit) var onSubmit
    @StateObject var keyboardType: CustomKeyboard
    
    public init(keyboardType: CustomKeyboard) {
        self._keyboardType = StateObject(wrappedValue: keyboardType)
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                keyboardType.onSubmit = onSubmit
            }
            .introspect(.textEditor, on: .iOS(.v15AndAbove)) { uiTextView in
                uiTextView.inputView = keyboardType.keyboardInputView
            }
    }
}

public struct CustomKeyboardModifierTextField: ViewModifier {
    @Environment(\.onSubmit) var onSubmit
    @StateObject var keyboardType: CustomKeyboard

    public init(keyboardType: CustomKeyboard) {
        self._keyboardType = StateObject(wrappedValue: keyboardType)
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                keyboardType.onSubmit = onSubmit
            }
            .introspect(.textField, on: .iOS(.v15AndAbove)) { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
            }
    }
}

