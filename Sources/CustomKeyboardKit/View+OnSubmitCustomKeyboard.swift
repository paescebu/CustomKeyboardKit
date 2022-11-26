//
//  View+OnSubmitCustomKeyboard.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

public struct OnSubmitCustomKeyboardKey: EnvironmentKey {
    public static let defaultValue: () -> () = { }
}

public extension EnvironmentValues {
  var onSubmit: () -> () {
    get { self[OnSubmitCustomKeyboardKey.self] }
    set { self[OnSubmitCustomKeyboardKey.self] = newValue }
  }
}

public extension View {
    func onSubmitCustomKeyboard(action: @escaping () -> ()) -> some View {
        self
            .environment(\.onSubmit, action)
    }
}
