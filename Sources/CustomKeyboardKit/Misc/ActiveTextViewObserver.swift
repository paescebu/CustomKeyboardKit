//
//  ActiveTextViewObserver.swift
//  CustomKeyboardKit
//
//  Created by Pascal Burlet on 29.09.2024.
//

import UIKit
import Combine

@MainActor
class ActiveTextViewObserver: NSObject, ObservableObject, Identifiable {
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var isEditing: Bool = false
    @Published private(set) var textView: UIView?

    func set<TextView: TextEditing>(textView: TextView) {
        Task {
            if textView != self.textView {
                self.textView = textView
            }
        }
        observeEditingState(for: textView)
    }
    
    private func observeEditingState<TextView: TextEditing>(for textView: TextView?) {
        cancellables.removeAll()
        guard let textView else { return }
        
        let didBeginEditingPublisher = NotificationCenter.default.publisher(for: TextView.textDidBeginEditingNotification, object: textView)
        let didEndEditingPublisher = NotificationCenter.default.publisher(for: TextView.textDidEndEditingNotification, object: textView)
        
        didBeginEditingPublisher
            .sink { [weak self] _ in
                self?.isEditing = true
            }
            .store(in: &cancellables)

        didEndEditingPublisher
            .sink { [weak self] _ in
                self?.isEditing = false
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
