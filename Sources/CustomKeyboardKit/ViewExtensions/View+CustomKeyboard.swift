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

public extension View {
    func customKeyboard(_ keyboardType: CustomKeyboard) -> some View {
        self
            .modifier(CustomKeyboardModifier(keyboardType: keyboardType))
    }
}

public struct CustomKeyboardModifier: ViewModifier {
    @Environment(\.onSubmit) var onSubmit
    var keyboardType: CustomKeyboard
    
    public init(keyboardType: CustomKeyboard) {
        self.keyboardType = keyboardType
    }
    
    public func body(content: Content) -> some View {
        content
            .introspectTextField { uiTextField in
                uiTextField.inputView = keyboardType.keyboardInputView
            }
            .onAppear {
                self.keyboardType.onSubmit = onSubmit
            }
    }
}
