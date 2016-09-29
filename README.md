

# NRControls

[![Version](https://img.shields.io/cocoapods/v/NRControls.svg?style=flat)](http://cocoapods.org/pods/NRControls)
[![License](https://img.shields.io/cocoapods/l/NRControls.svg?style=flat)](http://cocoapods.org/pods/NRControls)
[![Platform](https://img.shields.io/cocoapods/p/NRControls.svg?style=flat)](http://cocoapods.org/pods/NRControls)
![ScreenShot](https://cdn.rawgit.com/naveenrana1309/NRControls/master/Example/sample.png "Screeshot")

## Introduction

NRControls: This class is used for using a common controls like alert, action sheet and imagepicker controller with proper completion Handlers. It means when you open the image picker controller you dont worry about implementing the delegate of imagepickercontroller, instead you will get your selected image within the same line of code in completion handler. This library mainly contains the five methods which are for following purpose:
1) Imagepicker controller
2) AlertView
3) Action Sheet
4) AlertView with textfield (eg. you can use this in case of forgot password and in many more cases.)
5) Take or choose photo which use above methods and gives you the selected image within same line of code with the help of completion handler.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Xcode 8+ , Swift 3 , iOS 9 and above

## Installation

NRControls is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NRControls"
```

## Usage
# Take or Choose photo

```
@IBAction func takeChoosePhoto(sender: UIButton) {
NRControls.sharedInstance.takeOrChoosePhoto(self) { (selectedImage) in
self.imageView.image = selectedImage
}
}


```
# AlertView

```
@IBAction func alertViewButtonClicked(sender: UIButton) {
NRControls.sharedInstance.openAlertViewFromViewController(self, title: "Logout Alert", message: "Are you sure you want to logout?", buttonsTitlesArray: ["Cancel","Ok"]) { (alertController, index) in
print("index = \(index)")
}
}


```
# ActionSheet
```
@IBAction func actionSheetViewButtonClicked(sender: UIButton) {
NRControls.sharedInstance.openActionSheetFromViewController(self, title: "Action Sheet", message: "This is action sheet test message", buttonsTitlesArray: ["Login", "Logout"]) { (alertController, index) in
print("index = \(index)")

}
}



```
# Mail Composer
```
@IBAction func mailComposerButtonClicked(sender: UIButton) {
NRControls.sharedInstance.openMailComposerInViewController(["naveen.rana@appster.in"], viewcontroller: self) { (result, error) in
print(result)
}
}



```
# AlertView with TextField
```
@IBAction func alertViewWithTextFieldButtonClicked(sender: UIButton) {
NRControls.sharedInstance.openAlertViewWithTextFieldFromViewController(self, title: "TextField demo", message: "This is textfield test", placeHolder: "Enter your email", isSecure: false, buttonsTitlesArray: ["Cancel","Submit"], isNumberKeyboard: false) { (alertController, index, text) in
print(text)
}

}


```
#Xcode 7 support
if you want to use this in Xcode 7 and swift 2.3 you have to use pod 'NRControls', '~> 1.0'.

## Contributing

Contributions are always welcome! (:

1. Fork it ( http://github.com/naveenrana1309/NRControls/fork )
2. Create your feature branch ('git checkout -b my-new-feature')
3. Commit your changes ('git commit -am 'Add some feature')
4. Push to the branch ('git push origin my-new-feature')
5. Create new Pull Request

## Compatibility

Xcode 8+ , Swift 3 , iOS 9 and above

## Author

Naveen Rana. [See Profile](https://www.linkedin.com/in/naveen-rana-9a371a40)

Email: 
naveenrana1309@gmail.com. 

Check out [Facebook Page](https://www.facebook.com/iOSByHeart/) for detail.

## License

NRControls is available under the MIT license. See the LICENSE file for more info.
