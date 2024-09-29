//
//  KeyboardSoundEnablingView.swift
//  performify
//
//  Created by Pascal Burlet on 25.11.22.
//  Copyright © 2022 Pascal Burlet. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardInputView: UIView, UIInputViewAudioFeedback {
    var keyboardUIView: UIView
    
    public var enableInputClicksWhenVisible: Bool {
        true
    }
    
    init(keyboardUIView: UIView) {
        self.keyboardUIView = keyboardUIView
        keyboardUIView.backgroundColor = .clear
        keyboardUIView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(keyboardUIView)
        let constraints = [
            leadingAnchor.constraint(equalTo: keyboardUIView.leadingAnchor),
            trailingAnchor.constraint(equalTo: keyboardUIView.trailingAnchor),
            topAnchor.constraint(equalTo: keyboardUIView.topAnchor),
            bottomAnchor.constraint(equalTo: keyboardUIView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        backgroundColor = .clear
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return keyboardUIView.intrinsicContentSize
    }
}
