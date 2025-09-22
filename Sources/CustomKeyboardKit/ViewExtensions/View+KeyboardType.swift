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
            .keyboardType(keyboardType)
    }
}

public extension View {
    func keyboardType(_ keyboardType: Keyboard) -> some View {
        self
            .modifier(KeyboardModifier(keyboardType: keyboardType))
    }
}

public struct KeyboardModifier: ViewModifier {
    let keyboardType: Keyboard
    @Environment(\.onCustomSubmit) var onCustomSubmit
    @StateObject var textViewObserver = ActiveTextViewObserver()
    static var lastNativeKeyboard: UIKeyboardType? = nil
    
    public init(keyboardType: Keyboard) {
        self.keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .keyboardType(Self.lastNativeKeyboard ?? textViewObserver.textView?.keyboardType ?? .alphabet)
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
            Self.lastNativeKeyboard = systemKeyboard.keyboardType
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

// MARK: - ViewModifier to expose underlying UITextField
struct UITextFieldResolverModifier: ViewModifier {
    var onResolve: (UITextField) -> Void

    func body(content: Content) -> some View {
        content
            .background(ResolverView(onResolve: onResolve))
    }

    private struct ResolverView: UIViewRepresentable {
        var onResolve: (UITextField) -> Void

        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                if let tf = findTextField(from: view) {
                    onResolve(tf)
                }
            }
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}

        private func findTextField(from view: UIView) -> UITextField? {
            // Step 1: go up to parent to escape SwiftUI wrapper layers
            var parent: UIView? = view
            while let superview = parent?.superview {
                parent = superview
            }
            guard let root = parent else { return nil }

            // Step 2: recursively search down all subviews
            return searchSubviews(root)
        }

        private func searchSubviews(_ view: UIView) -> UITextField? {
            if let tf = view as? UITextField { return tf }
            for subview in view.subviews {
                if let found = searchSubviews(subview) {
                    return found
                }
            }
            return nil
        }
    }
}

// MARK: - Convenience extension
extension View {
    func resolveUITextField(_ callback: @escaping (UITextField) -> Void) -> some View {
        modifier(UITextFieldResolverModifier(onResolve: callback))
    }
}
