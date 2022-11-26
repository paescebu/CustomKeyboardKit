# CustomKeyboardKit
Creating Custom In App Keyboards with SwiftUI has never been easier than with this Swift Package

You can now build a Keyboard with 100% SwiftUI for your SwiftUI or UIKit App!

## Features
- Build the entire keyboard layout in SwiftUI
- Use it in UIKit or SwiftUI
- Use it parallelly to any native keyboard
- Works flawlessly on iOS and iPadOS

## Creating the Keyboard
Simply extend the CustomKeyboard class and provide a static property and use the CustomKeyboardBuilder: 
```swift
    extension CustomKeyboard {
        static var yesnt = CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
            VStack {
                HStack {
                    Button("Yes!") {
                        textDocumentProxy.insertText("Yes")
                        playSystemFeedback?()
                    }
                    Button("No!") {
                        textDocumentProxy.insertText("No")
                        playSystemFeedback?()
                    }
                }
                Button("Maybe") {
                    textDocumentProxy.insertText("?")
                    playSystemFeedback?()
                }
                Button("Idk") {
                    textDocumentProxy.insertText("Idk")
                    playSystemFeedback?()
                }
                Button("Can you repeat the question?") {
                    playSystemFeedback?()
                    submit?()
                }
            }
            .buttonStyle(.bordered)
            .padding()
        }
    }
```

## Using My Custom Keyboard in SwiftUI
Once declared, you can use the custom keyboard with the `.customKeyboard(:)` View modifer and using your statically defined property
```swift
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
```

## Using My Custom KEyboard in UIKit
Once declared, you can assign your `CustomKeyboard`'s `keyboardInputView` property to the UITextFields `inputView`.
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let customKeyboard =  CustomKeyboard.yesnt
        customKeyboard.onSubmit = { print("do something when SubmitHandler called") }
        
        myTextField.inputView = customKeyboard.keyboardInputView
    }
```

## Warranty
The code comes with no warranty of any kind. I hope it'll be useful to you (it certainly is to me), but I make no guarantees regarding its functionality or otherwise.

## Special Thanks
Special thanks goes to the user @crayment which made it particularly easy for me with SwiftUI-Introspect to apply the Custom Keyboard to SwiftUI TextFields.

