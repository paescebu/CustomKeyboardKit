//
//  CustomKeyboardBuilder.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import UIKit
import SwiftUI

///This is an example if an implementation for a custom keyboard.
///- `UITextDocumentProxy` provides you the capability to modify the text thats in focus (e.g. inserting characters or strings, deleting backwards etc.),
///- `SubmitHandler?` closure parameter is a closure, when called triggers the registered closure (using the `.onSubmitCustomKeyboard(:)` modiifer.
///- `SystemFeedbackHandler?` closure parameter is a closure, when called will play the keyboard system sounds and haptic feedback if enabled in the settings by the user
public class CustomKeyboardBuilder: CustomKeyboard {
    public init(@ViewBuilder customKeyboardView: @escaping ((UITextDocumentProxy, SubmitHandler?, SystemFeedbackHandler?) -> some View)) {
        super.init(nibName: nil, bundle: nil)
        
        let keyboardViewController = UIHostingController(
            rootView: customKeyboardView(self.textDocumentProxy, { self.onSubmit?() }, playSystemFeedback)
        )
        keyboardViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        keyboardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardViewController = keyboardViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
