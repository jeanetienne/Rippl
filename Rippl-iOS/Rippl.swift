//
//  Rippl.swift
//  Rippl
//
//  Created by Jean-Étienne Parrot on 13/10/2016.
//  Copyright © 2016 Jean-Étienne. All rights reserved.
//

import UIKit

@IBDesignable
public class Rippl: UIView {

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

    required public init?(coder aDecoder: NSCoder) {
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
    
    override public func layoutSubviews() {
        let bezierPath = UIBezierPath.init(ovalIn: bounds)
        bezierLayer.path = bezierPath.cgPath
        bezierLayer.fillColor = fillColor.cgColor
        bezierLayer.strokeColor = borderColor.cgColor
        bezierLayer.lineWidth = borderWidth
    }

    public func animateImpact(strength: CGFloat, duration: CFTimeInterval) {
        let ripplLayer = Rippl.copy(layer: bezierLayer)
        ripplLayer.zPosition = 0
        bezierLayer.addSublayer(ripplLayer)

        animateImpactGrowth(layer: ripplLayer, strength: strength, duration: duration)
        animateImpactOpacity(layer: ripplLayer, opacity: 0, duration: duration)

        Rippl.remove(layer: ripplLayer, afterDuration: duration + 0.1)
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

        layer.add(Rippl.basicAnimation(keyPath: "path",
                                        value: bezierPath.cgPath,
                                        duration: duration,
                                        timingFunction: kCAMediaTimingFunctionEaseOut),
                  forKey: "impactGrowth")
    }
    
    private func animateImpactOpacity(layer: CAShapeLayer, opacity: CGFloat, duration: CFTimeInterval) {
        layer.add(Rippl.basicAnimation(keyPath: "fillColor",
                                        value: fillColor.withAlphaComponent(opacity).cgColor,
                                        duration: duration,
                                        timingFunction: kCAMediaTimingFunctionLinear),
                  forKey: "impactFillColor")

        layer.add(Rippl.basicAnimation(keyPath: "strokeColor",
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
        let ripplLayer = CAShapeLayer()
        ripplLayer.path = layer.path
        ripplLayer.fillColor = layer.fillColor
        ripplLayer.strokeColor = layer.strokeColor
        ripplLayer.lineWidth = layer.lineWidth

        return ripplLayer
    }

    private static func remove(layer: CALayer, afterDuration duration: CFTimeInterval) {
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration * 1000))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            layer.removeFromSuperlayer()
        }
    }
}
