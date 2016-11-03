# Rippl

[![Version](https://img.shields.io/cocoapods/v/Rippl.svg?style=flat)](http://cocoapods.org/pods/Rippl)
[![License](https://img.shields.io/cocoapods/l/Rippl.svg?style=flat)](http://cocoapods.org/pods/Rippl)
[![Platform](https://img.shields.io/cocoapods/p/Rippl.svg?style=flat)](http://cocoapods.org/pods/Rippl)

UI element showing a growing circle, reminiscent of a ripple in a pond.

A Rippl is a simple UIView sublcass which draws an ellipse (most probably a circle) within its frame and has 2 built-in animations. You can call an "impact ripple" to create an additional growing ellipse behind the original one, or you can call a "gain" animation that grows the original view according to the value of the gain.

![Impact Ripple animation](https://raw.githubusercontent.com/jeanetienne/rippl/master/impact.gif)
![Gain animation](https://raw.githubusercontent.com/jeanetienne/rippl/master/gain.gif)

## Features
Rippl is IBDesignable and IBInspectable, making it very easy to use in Interface Builder.

## Sample project
Clone this repo and run the project, it contains a sound recorder to help you visualise the "gain" animation. You can also trigger the "impact ripple" animation with a button.

The mic image in the sample project is by [Michal Beno](https://thenounproject.com/term/microphone/636702/), from the Noun Project.