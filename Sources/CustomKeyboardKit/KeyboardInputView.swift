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
        super.init(frame: .zero)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(keyboardUIView)
        let constraints = [
            self.leadingAnchor.constraint(equalTo: keyboardUIView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: keyboardUIView.trailingAnchor),
            self.topAnchor.constraint(equalTo: keyboardUIView.topAnchor),
            self.bottomAnchor.constraint(equalTo: keyboardUIView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        self.backgroundColor = .clear
        keyboardUIView.backgroundColor = .clear
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return keyboardUIView.intrinsicContentSize
    }
}
