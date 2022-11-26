//
//  File.swift
//  
//
//  Created by Pascal Burlet on 26.11.22.
//

import Foundation
import SwiftUI

///Once declared, you can use the custom keyboard with the `.customKeyboard(:)` View modifer and using your statically defined property
struct ContentView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Text(text)
            TextField("", text: $text)
                .customKeyboard(.yesnt)
                .onSubmitCustomKeyboard {
                    print("do something when SubmitHandler called")
                }
        }
    }
}
