//
//  File.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import UIKit
import SwiftUI

public class CustomKeyboardBuilder: CustomKeyboard {
    public init(@ViewBuilder customKeyboardView: @escaping ((UITextDocumentProxy, SubmitHandler?, SystemFeedbackHandler?) -> some View)) {
        super.init(nibName: nil, bundle: nil)
        let keyboardViewController = UIHostingController(
            rootView: customKeyboardView(self.textDocumentProxy, { self.onSubmit?() }, playSystemFeedback)
        )
        keyboardViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        keyboardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardViewController = keyboardViewController
        self.keyboardInputView = KeyboardSoundEnablingView(keyboardUIView: keyboardViewController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
