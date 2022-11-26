//
//  CustomKeyboard.swift
//  performify
//
//  Created by Pascal Burlet on 25.11.22.
//  Copyright © 2022 Pascal Burlet. All rights reserved.
//

import Foundation
import UIKit

public class CustomKeyboard: UIInputViewController {
    public typealias SubmitHandler = () -> ()
    public typealias SystemFeedbackHandler = () -> ()
    
    internal var keyboardViewController: UIViewController! = nil
    internal var keyboardInputView: KeyboardSoundEnablingView = KeyboardSoundEnablingView(keyboardUIView: UIView())
    internal var onSubmit: SubmitHandler? = nil
    internal var playSystemFeedback: SystemFeedbackHandler? = UIDevice.current.playInputClick
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let inputView else { return }
        addChild(keyboardViewController)
        inputView.addSubview(keyboardInputView)
        keyboardViewController.didMove(toParent: self)
        let constraints = [
            keyboardInputView.leadingAnchor.constraint(equalTo: inputView.leadingAnchor),
            keyboardInputView.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
            keyboardInputView.topAnchor.constraint(equalTo: inputView.topAnchor),
            keyboardInputView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        keyboardInputView.backgroundColor = .clear
        inputView.backgroundColor = .clear
    }
}
