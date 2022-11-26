//
//  YesntKeyboard.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI
import UIKit

///This is an example if an implementation for a custom keyboard.
///- `UITextDocumentProxy` provides you the capability to modify the text thats in focus (e.g. inserting characters or strings, deleting backwards etc.),
///- `SubmitHandler?` closure parameter is a closure, when called triggers the registered closure (using the `.onSubmitCustomKeyboard(:)` modiifer.
///- `SystemFeedbackHandler?` closure parameter is a closure, when called will play the keyboard system sounds and haptic feedback if enabled in the settings by the user
extension CustomKeyboard {
    static var yesnt = CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
        VStack {
            HStack {
                Button("Yes!") {
                    textDocumentProxy.insertText("Yes")
                    playSystemFeedback?()
                }
                Button("No!") {
                    textDocumentProxy.insertText("No")
                    playSystemFeedback?()
                }
            }
            Button("Idk") {
                textDocumentProxy.insertText("Idk")
                playSystemFeedback?()
            }
            Button("Can you repeat the question?") {
                playSystemFeedback?()
                submit?()
            }
        }
        .buttonStyle(.bordered)
        .padding()
    }
}
