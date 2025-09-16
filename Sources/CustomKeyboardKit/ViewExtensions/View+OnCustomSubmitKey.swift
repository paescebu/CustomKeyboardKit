//
//  View+OnCustomSubmitKey.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

public struct OnCustomSubmitKey: EnvironmentKey {
    public static let defaultValue: Keyboard.SubmitHandler? = nil
}

public extension EnvironmentValues {
  var onCustomSubmit: Keyboard.SubmitHandler? {
    get { self[OnCustomSubmitKey.self] }
    set { self[OnCustomSubmitKey.self] = newValue }
  }
}

public extension View {
    func onCustomSubmit(action: @escaping Keyboard.SubmitHandler) -> some View {
        self
            .environment(\.onCustomSubmit, action)
    }
}
