//
//  Ripple.swift
//  Ripple
//
//  Created by Jean-Étienne Parrot on 13/10/2016.
//  Copyright © 2016 Jean-Étienne. All rights reserved.
//

import UIKit

@IBDesignable
class Ripple: UIView {

    @IBInspectable public var fillColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            bezierLayer.fillColor = fillColor.cgColor
        }
    }

    @IBInspectable public var borderColor: UIColor = UIColor.black.withAlphaComponent(0.7) {
        didSet {
            bezierLayer.strokeColor = borderColor.cgColor
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 3.0 {
        didSet {
            bezierLayer.lineWidth = borderWidth
        }
    }

    private var bezierLayer: CAShapeLayer

    required init?(coder aDecoder: NSCoder) {
        bezierLayer = CAShapeLayer()
        bezierLayer.zPosition = 1

        super.init(coder: aDecoder)

        layer.addSublayer(bezierLayer)
    }
    
    override init(frame: CGRect) {
        bezierLayer = CAShapeLayer()

        super.init(frame: frame)

        layer.addSublayer(bezierLayer)
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        let bezierPath = UIBezierPath.init(ovalIn: bounds)
        bezierLayer.path = bezierPath.cgPath
        bezierLayer.fillColor = fillColor.cgColor
        bezierLayer.strokeColor = borderColor.cgColor
        bezierLayer.lineWidth = borderWidth
    }

    public func animateImpact(strength: CGFloat, duration: CFTimeInterval) {
        let rippleLayer = Ripple.copy(layer: bezierLayer)
        rippleLayer.zPosition = 0
        bezierLayer.addSublayer(rippleLayer)

        animateImpactGrowth(layer: rippleLayer, strength: strength, duration: duration)
        animateImpactOpacity(layer: rippleLayer, opacity: 0, duration: duration)

        Ripple.remove(layer: rippleLayer, afterDuration: duration + 0.1)
    }

    public func animateGain(value: CGFloat) {
        if let originalPath = (layer.presentation()?.sublayers?.first as? CAShapeLayer)?.path {

            let keyTime = 0.3
            let durationConstant = 1.8

            let newBounds = bounds.insetBy(dx: (bounds.width - (bounds.width * value)) / 2,
                                           dy: (bounds.height - (bounds.height * value)) / 2)
            let bezierPath = UIBezierPath.init(ovalIn: newBounds)

            let animation = CAKeyframeAnimation()
            animation.keyPath = "path"
            animation.calculationMode = kCAAnimationLinear
            animation.values = [originalPath, bezierPath.cgPath, originalPath]
            animation.keyTimes = [0, NSNumber(value: keyTime), 1]
            animation.duration = 0.1 * durationConstant
            bezierLayer.add(animation, forKey: "gainGrowth")
        }
    }

    // MARK: - Private animations
    private func animateImpactGrowth(layer: CAShapeLayer, strength: CGFloat, duration: CFTimeInterval) {
        let newBounds = bounds.insetBy(dx: (bounds.width - (bounds.width * strength)) / 2,
                                       dy: (bounds.height - (bounds.height * strength)) / 2)
        let bezierPath = UIBezierPath.init(ovalIn: newBounds)

        layer.add(Ripple.basicAnimation(keyPath: "path",
                                        value: bezierPath.cgPath,
                                        duration: duration,
                                        timingFunction: kCAMediaTimingFunctionEaseOut),
                  forKey: "impactGrowth")
    }
    
    private func animateImpactOpacity(layer: CAShapeLayer, opacity: CGFloat, duration: CFTimeInterval) {
        layer.add(Ripple.basicAnimation(keyPath: "fillColor",
                                        value: fillColor.withAlphaComponent(opacity).cgColor,
                                        duration: duration,
                                        timingFunction: kCAMediaTimingFunctionLinear),
                  forKey: "impactFillColor")

        layer.add(Ripple.basicAnimation(keyPath: "strokeColor",
                                        value: borderColor.withAlphaComponent(opacity).cgColor,
                                        duration: duration,
                                        timingFunction: kCAMediaTimingFunctionLinear),
                  forKey: "impactStrokeColor")
    }
    
    // MARK: - Private helpers
    private static func basicAnimation(keyPath: String, value: Any, duration: CFTimeInterval, timingFunction: String) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: keyPath)
        basicAnimation.toValue = value
        basicAnimation.duration = duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false

        return basicAnimation
    }

    private static func copy(layer: CAShapeLayer) -> CAShapeLayer {
        let rippleLayer = CAShapeLayer()
        rippleLayer.path = layer.path
        rippleLayer.fillColor = layer.fillColor
        rippleLayer.strokeColor = layer.strokeColor
        rippleLayer.lineWidth = layer.lineWidth

        return rippleLayer
    }

    private static func remove(layer: CALayer, afterDuration duration: CFTimeInterval) {
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            layer.removeFromSuperlayer()
        }
    }
}
