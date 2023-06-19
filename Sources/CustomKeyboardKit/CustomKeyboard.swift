//
//  CustomKeyboard.swift
//  performify
//
//  Created by Pascal Burlet on 25.11.22.
//  Copyright © 2022 Pascal Burlet. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public class CustomKeyboard: UIInputViewController, ObservableObject {
    public typealias SubmitHandler = () -> ()
    public typealias SystemFeedbackHandler = () -> ()
    
    public private(set) lazy var keyboardInputView = KeyboardInputView(keyboardUIView: keyboardView)
    public var onSubmit: SubmitHandler? = nil
    
    internal var keyboardView: UIView! = nil
    internal var playSystemFeedback: SystemFeedbackHandler? = UIDevice.current.playInputClick
    
    override public var view: UIView! {
        get {
            return keyboardInputView
        }
        set { }
    }
}
