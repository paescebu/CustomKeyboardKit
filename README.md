# CustomKeyboardKit
I strongly believe that any in app keyboard layout is best built in SwiftUI, no matter if its used in SwiftUI or UIKit. 
With that lightweight package I think I offer you the necessary tools to do so in the UI Framework that we all started to embrace and love. SwiftUI!

My goal is to keep this framework as lightweight as it is, to not add bloat to it with features most people do not need. This ensures keeping the complexity of the package at its minimum, which translates to a certain stability and reliability. 
I sincerely hope with this package I managed to deliver pretty much unrestricted possibilities for you.

## Features
- Build the entire keyboard layout in SwiftUI
    - Doesn't even have to be a keyboard, **build literally anything that pops up for focused text fields!**
- Can play native iOS/iPadOS keyboard sounds and haptic feedback
- Use it in UIKit or SwiftUI
- Interact with the focused text using the UITextDocumentProxy closure parameter
- Use it parallelly to any native keyboard
- Works with SwiftUI's new `scrollDismissesKeyboard(:)` modifiers etc.
- Works flawlessly on iOS and iPadOS
- Works with the native `onSubmit` modifier, but behaviour can be fully customized by using `onCustomSubmit` instead

## Creating the Keyboard
Simply extend the CustomKeyboard class and provide a static computed property and use the CustomKeyboardBuilder, additionally use the `UITextDocumentProxy` instance to modify/delete the focused text and move the cursor. Use the playSystemFeedback closure to play system sounds on `Button` presses. See the example below: 
```swift
extension CustomKeyboard {
    static var yesnt: CustomKeyboard {
        CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
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
}
```

## Using Your Custom Keyboard In SwiftUI
Once declared, you can use the custom keyboard with the `.customKeyboard(:)` View modifer and using your statically defined property
```swift
struct ContentView: View {
    @State var text: String = ""

    var body: some View {
        VStack {
            Text(text)
            TextField("", text: $text)
                .customKeyboard(.yesnt)
                .onCustomSubmit {
                    print("do something when SubmitHandler called")
                }

        }
    }
}
```

## About Customizing The Submit Button Tap Behaviour
The custom keyboard supports the native `onSubmit` modifier to pass a closure to perform actions after the submit button has been tapped.
In order to fully customize the behaviour of the submit button to not follow the native behaviour (e.g. not closing the keyboard) the `onCustomSubmit` modifier shall be used.
```swift
struct ContentView: View {
    @State var text: String = ""

    var body: some View {
        VStack {
            Text(text)
            TextField("", text: $text)
                .customKeyboard(.yesnt)
                .onCustomSubmit {
                    print("do something when SubmitHandler has been called")
                }

        }
    }
}
```
If both modifiers are used `onCustomSubmit` takes precendece over `onSubmit` and performs the closure inside `onCustomSubmit` only. So please make sure to only use one of the two ideally.

## Using Your Custom Keyboard In UIKit
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

## Alternative direct SwiftUI use:
You can also directly use the `customKeyboard(view:)` modifier that allows you to build the custom keyboard within the view body itself, if you need to access some View properties or constants etc. 
Example:
```swift
struct ContentView: View {
    @State var text = "0"
    
    var body: some View {
        TextField("", text: $text)
            .customKeyboard { textDocumentProxy, onSubmit, playFeedback in
                VStack {
                    numberButton(text: "1", uiTextDocumentProxy: textDocumentProxy, playFeedback: playFeedback)
                    numberButton(text: "2", uiTextDocumentProxy: textDocumentProxy, playFeedback: playFeedback)
                    Button("DEL") {
                        textDocumentProxy.deleteBackward()
                        playFeedback?()
                    }
                }
            }
    }
    
    func numberButton(text: String, uiTextDocumentProxy: UITextDocumentProxy, playFeedback: (() -> ())?) -> some View {
        Button(text) {
            uiTextDocumentProxy.insertText(text)
            playFeedback?()
        }
    }
}
```
This works equally with `TextEditor`


## Complete Example
Check out the video below for the following example code and see how it works perfectly side by side with native keyboards.

```swift
struct ContentView: View {
    @State var text0: String = ""
    @State var text1: String = ""
    @State var text2: String = ""
    @State var text3: String = ""

    var body: some View {
        VStack {
            Group {
                TextField("ABC", text: $text0)
                    .customKeyboard(.alphabet)
                TextField("Numpad", text: $text1)
                    .keyboardType(.numberPad)
                TextField("ABC", text: $text2)
                    .customKeyboard(.alphabet)
                TextField("Normal", text: $text3)
                    //normal keyboard
            }
            .background(Color.gray)
        }
        .padding()
    }
}

extension CustomKeyboard {
    static var alphabet: CustomKeyboard {
        CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { $0 }
            let gridItem = GridItem.init(.adaptive(minimum: 25))

            return LazyVGrid(columns: [gridItem], spacing: 5) {
                ForEach(letters, id: \.self) { char in
                    Button(char.uppercased()) {
                        textDocumentProxy.insertText("\(char)")
                        playSystemFeedback?()
                    }
                    .frame(width: 25, height: 40)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .frame(height: 150)
            .padding()
        }
    }
}
```

https://user-images.githubusercontent.com/59558722/204609124-b99b0d8d-f38f-42d3-afa5-cbf7e72e86c8.mp4

## Warranty
The code comes with no warranty of any kind. I hope it'll be useful to you (it certainly is to me), but I make no guarantees regarding its functionality or otherwise.

## Donations
You really don't have to pay anything to use this package. But if you feel generous today and would like to donate because this package helped you so much, here's a PayPal donation link:
https://www.paypal.com/donate/?hosted_button_id=JYL8DBGA2X4YQ

or just buy me a hot chocolate:
https://www.buymeacoffee.com/paescebu
