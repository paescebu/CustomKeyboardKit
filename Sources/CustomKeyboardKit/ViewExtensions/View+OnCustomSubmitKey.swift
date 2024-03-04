//
//  View+OnCustomSubmitKey.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

public struct OnCustomSubmitKey: EnvironmentKey {
    public static let defaultValue: CustomKeyboard.SubmitHandler? = nil
}

public extension EnvironmentValues {
  var onCustomSubmit: CustomKeyboard.SubmitHandler? {
    get { self[OnCustomSubmitKey.self] }
    set { self[OnCustomSubmitKey.self] = newValue }
  }
}

public extension View {
    @available(*, deprecated, renamed: "onCustomSubmit(action:)")
    func onSubmitCustomKeyboard(action: @escaping () -> Void) -> some View {
        self
            .onCustomSubmit(action: action)
    }
}

public extension View {
    func onCustomSubmit(action: @escaping CustomKeyboard.SubmitHandler) -> some View {
        self
            .environment(\.onCustomSubmit, action)
    }
}
