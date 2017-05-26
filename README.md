# UIFloatPHTextField

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## Installation 

### CocoaPods (Recommended)

Install CocoaPods if not already available:
``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Go to the directory of your Xcode project, and Create and Edit your Podfile and add UIFloatPHTextField.swift to your corresponding TargetName:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'TargetName' do
    pod 'UIFloatPHTextField.swift', '~> 0.2.0'
end
```
Install into your project:

``` bash
$ pod install
```
Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `QRCodeReader` into your Xcode project using Carthage, specify it in your `Cartfile` file:

```ogdl
github "sawijaya/UIFloatPHTextField.swift" >= 0.2.0

### Manually

1. Simply download the `UIFloatPHTextField.swift`, `UIDropdownTextField.swift` and `Resources/Images/*` files from [here](https://github.com/luispadron/UICircularProgressRing/tree/master/UICircularProgressRing) into your project, make sure you point to your projects target
