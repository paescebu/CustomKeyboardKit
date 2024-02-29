//
//  View+OnSubmitCustomKeyboard.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

public struct OnCustomSubmitCustomKeyboardKey: EnvironmentKey {
    public static let defaultValue: CustomKeyboard.SubmitHandler? = nil
}

public extension EnvironmentValues {
  var onCustomSubmit: CustomKeyboard.SubmitHandler? {
    get { self[OnCustomSubmitCustomKeyboardKey.self] }
    set { self[OnCustomSubmitCustomKeyboardKey.self] = newValue }
  }
}

public extension View {
    func onCustomSubmit(action: @escaping CustomKeyboard.SubmitHandler) -> some View {
        self
            .environment(\.onCustomSubmit, action)
    }
}
