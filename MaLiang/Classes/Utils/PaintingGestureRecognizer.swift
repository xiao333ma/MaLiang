//
//  PaintingGestureRecognizer.swift
//  MaLiang
//
//  Created by Harley.xk on 2018/5/3.
//

import UIKit.UIGestureRecognizerSubclass


class PaintingGestureRecognizer: UIPanGestureRecognizer {

    private var targetView: UIView
    
    @discardableResult
    class func addToTarget(_ target: UIView, action: Selector) -> PaintingGestureRecognizer {
        let ges = PaintingGestureRecognizer(target: target, action: action)
        target.addGestureRecognizer(ges)
        return ges
    }
    
    init(target: UIView, action: Selector?) {
        targetView = target
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
        
    }
    
    /// 当前压力值，启用压力感应时，使用真实的压力，否则使用模拟压感
    var force: CGFloat = 1
    
    /// 是否启用压力感应，默认开启
    var forceEnabled = true
    
    private func updateForceFromTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        if forceEnabled, touch.force > 0 {
            force = touch.force / 3
            return
        }
        
        let vel = velocity(in: targetView)
        var length = vel.distance(to: .zero)
        length = min(length, 5000)
        length = max(100, length)
        force = sqrt(1000 / length)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        updateForceFromTouches(touches)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        updateForceFromTouches(touches)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        updateForceFromTouches(touches)
        super.touchesEnded(touches, with: event)
    }
}
