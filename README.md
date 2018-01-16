# Rippl

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/jeanetienne/Rippl/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Rippl.svg?style=flat)](https://cocoapods.org/pods/Rippl)
[![Platform](https://img.shields.io/cocoapods/p/Rippl.svg?style=flat)](http://cocoapods.org/pods/Rippl)

UI element showing a growing circle, reminiscent of a ripple in a pond.

A Rippl is a simple UIView sublcass which draws an ellipse (in most cases a circle) within its frame and has 2 built-in animations. An "impact ripple" animation to create an additional growing ellipse behind the original one, and a "gain" animation that grows the original view according to the value of the gain.

![Impact Ripple animation](https://raw.githubusercontent.com/jeanetienne/rippl/master/impact.gif)
![Gain animation](https://raw.githubusercontent.com/jeanetienne/rippl/master/gain.gif)

## Features
Rippl is IBDesignable and IBInspectable, making it very easy to use in Interface Builder.

## Usage
Use a UIView of subclass `Rippl` and call any of the two provided methods:

```swift
class ViewController: UIViewController {

    @IBOutlet var ripplView: Rippl!

    @IBAction func animateImpactButtonDidTouchUpInside(_ sender: AnyObject, forEvent event: UIEvent) {
        ripplView.animateImpact(strength: 2.5, duration: 1.5)
    }

    @IBAction func animateGainButtonDidTouchUpInside(_ sender: AnyObject, forEvent event: UIEvent) {
        ripplView.animateGain(value: 3)
    }

}
````

## Installation

### Cocoapods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Rippl into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
  pod 'Rippl'
```

Then, run the following command:

```bash
$ pod install
```


### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Rippl into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "jeanetienne/Rippl"
```

Run `carthage update` to build the framework and drag the built `Rippl.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Rippl into your project manually.

## Sample project
Clone this repo and run the project, it contains a sound recorder to help you visualise the "gain" animation. You can also trigger the "impact ripple" animation with a button.

The mic image in the sample project is by [Michal Beno](https://thenounproject.com/term/microphone/636702/), from the Noun Project.
