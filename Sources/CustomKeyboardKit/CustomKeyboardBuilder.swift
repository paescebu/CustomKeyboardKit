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
        let viewController = UIHostingController(
            rootView: customKeyboardView(self.textDocumentProxy, { self.onSubmit?() }, playSystemFeedback)
        )
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.viewController = viewController
        self.keyboardInputView = KeyboardSoundEnablingView(wrappedView: viewController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
