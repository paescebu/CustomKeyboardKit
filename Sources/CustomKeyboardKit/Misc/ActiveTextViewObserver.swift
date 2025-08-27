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
    @Published private(set) var textView: (any TextEditing)?

    func set<TextView: TextEditing>(textView: TextView) {
        if self.textView == nil {
            Task {
                self.textView = textView
                observeEditingState(for: textView)
            }
            return
        }
        
        if textView == self.textView! {
            Task {
                self.textView = textView
                observeEditingState(for: textView)
            }
        }
    }
    
    private func observeEditingState<TextView: TextEditing>(for textView: TextView) {
        cancellables.removeAll()
        
        let beginEditing = NotificationCenter.default.publisher(for: TextView.textDidBeginEditingNotification, object: textView)
            .map { _ in true }
        let endEditing = NotificationCenter.default.publisher(for: TextView.textDidEndEditingNotification, object: textView)
            .map { _ in false }
        
        Publishers.Merge(beginEditing, endEditing)
            .assign(to: \.isEditing, on: self)
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
