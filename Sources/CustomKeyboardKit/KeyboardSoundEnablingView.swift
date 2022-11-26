//
//  KeyboardSoundEnablingView.swift
//  performify
//
//  Created by Pascal Burlet on 25.11.22.
//  Copyright © 2022 Pascal Burlet. All rights reserved.
//

import Foundation
import UIKit

internal class KeyboardSoundEnablingView: UIView, UIInputViewAudioFeedback {
    var wrappedView: UIView
    
    var enableInputClicksWhenVisible: Bool {
        true
    }
    
    init(wrappedView: UIView) {
        self.wrappedView = wrappedView
        super.init(frame: .null)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(wrappedView)
        let constraints = [
            self.leadingAnchor.constraint(equalTo: wrappedView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: wrappedView.trailingAnchor),
            self.topAnchor.constraint(equalTo: wrappedView.topAnchor),
            self.bottomAnchor.constraint(equalTo: wrappedView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        self.backgroundColor = .clear
        wrappedView.backgroundColor = .clear
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return wrappedView.intrinsicContentSize
    }
}
