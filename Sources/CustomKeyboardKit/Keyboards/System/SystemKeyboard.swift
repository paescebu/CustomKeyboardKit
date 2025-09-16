//
//  SystemKeyboard.swift
//  CustomKeyboardKit
//
//  Created by Pascal Burlet on 16.09.2025.
//

import Foundation
import UIKit

public extension Keyboard {
    static func system(_ keyboardType: UIKeyboardType) -> Keyboard {
        SystemKeyboard(keyboardType: keyboardType)
    }
}

internal class SystemKeyboard: Keyboard {
    let keyboardType: UIKeyboardType
    
    init(keyboardType: UIKeyboardType) {
        self.keyboardType = keyboardType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
