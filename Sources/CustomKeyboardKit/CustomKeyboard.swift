//
//  CustomKeyboard.swift
//  performify
//
//  Created by Pascal Burlet on 25.11.22.
//  Copyright © 2022 Pascal Burlet. All rights reserved.
//

import Foundation
import UIKit

public class CustomKeyboard: UIInputViewController, ObservableObject {
    public typealias SubmitHandler = () -> ()
    public typealias SystemFeedbackHandler = () -> ()
    public lazy var keyboardInputView = KeyboardInputView(keyboardUIView: keyboardViewController.view)
    public var onSubmit: SubmitHandler? = nil

    internal var keyboardViewController: UIViewController! = nil
    internal var playSystemFeedback: SystemFeedbackHandler? = UIDevice.current.playInputClick
    
    override public var view: UIView! {
        get {
            return keyboardInputView
        }
        set { }
    }
    
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
