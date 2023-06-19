//
//  CustomKeyboardModifier.swift
//  
//
//  Created by PascalBurlet on 30.06.22.
//

import Foundation
import UIKit
import SwiftUI
import Introspect

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
            .introspectTextViewWithClipping { uiTextView in
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
                self.keyboardType.onSubmit = onSubmit
            }
            .introspectTextFieldWithClipping { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
            }
    }
}



extension View {
    //Makes it more reliable for UITextField if stylings are added
    //A workaround for views that might have clipping, according to following issue
    //https://github.com/siteline/SwiftUI-Introspect/issues/115#issuecomment-1013653286
    public func introspectTextFieldWithClipping(customize: @escaping (UITextField) -> ()) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                // first run Introspect as normal
                if let selectedView = Introspect.previousSibling(containing: UITextField.self, from: viewHost) {
                    return selectedView
                } else if let superView = viewHost.superview {
                    // if no view was found and a superview exists, search the superview as well
                    return Introspect.previousSibling(containing: UITextField.self, from: superView)
                } else {
                    // no view found at all
                    return nil
                }
            },
            customize: customize
        ))
    }
    
    //Makes it more reliable for UITextView if stylings are added
    //A workaround for views that might have clipping, according to following issue
    //https://github.com/siteline/SwiftUI-Introspect/issues/115#issuecomment-1013653286
    public func introspectTextViewWithClipping(customize: @escaping (UITextView) -> ()) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                // first run Introspect as normal
                if let selectedView = Introspect.previousSibling(containing: UITextView.self, from: viewHost) {
                    return selectedView
                } else if let superView = viewHost.superview {
                    // if no view was found and a superview exists, search the superview as well
                    return Introspect.previousSibling(containing: UITextView.self, from: superView)
                } else {
                    // no view found at all
                    return nil
                }
            },
            customize: customize
        ))
    }
}
