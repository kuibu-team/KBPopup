//
//  KBPopupView.swift
//  KBPopup
//
//  Created by 张鹏 on 2021/6/9.
//

import UIKit
import KBDecorationView

/// 弹出框
@objc
open class KBPopupView: KBDecorationView {
        
    // MARK: - Public Properties
    
    /// 箭头高度
    @objc
    public var arrowHeight: CGFloat = 10 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// 箭头的圆角半径
    @objc
    public var arrowCornerRadius: CGFloat = 3
        
    /// 圆角半径
    @objc
    public var cornerRadius: CGFloat = 8
    
    /// 弹窗的外边距
    @objc
    public var margin: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    /// 显示弹窗的来源视图，与`sourceFrame`二选一，优先使用`sourceFrame`
    @objc
    public var sourceView: UIView?
    
    /// 显示弹窗的来源位置，与`sourceView`二选一，优先使用`sourceFrame`
    @objc
    public var sourceFrame: CGRect = .zero
    
    
    // MARK: - Private Properties
    
    /// 箭头方向
    @objc
    private var arrowDirection: ArrowDirection = .down {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 箭头的尺寸
    private var arrowSize: CGSize {
        return CGSize(width: arrowHeight*2, height: arrowHeight)
    }
    
    /// 箭头顶点X轴偏移
    @objc
    private var arrowVertexXOffset: CGFloat = 0
        
    /// 箭头顶点位置
    private var arrowVertexPosition: CGPoint {
        var arrowVertexY: CGFloat = 0;
        switch (arrowDirection) {
        case .down:
            arrowVertexY = bounds.size.height
        case .up:
            arrowVertexY = 0
        }
        
        var arrowVertexX: CGFloat = bounds.size.width/2.0 + arrowVertexXOffset
        if arrowVertexX < (cornerRadius + arrowSize.width/2.0) {
            arrowVertexX = cornerRadius + arrowSize.width/2.0
        }
        
        if arrowVertexX > (bounds.width - cornerRadius - arrowSize.width/2.0) {
            arrowVertexX = bounds.width - cornerRadius - arrowSize.width/2.0
        }
        
        return CGPoint(x: arrowVertexX, y: arrowVertexY)
    }
    
    /// 箭头圆角中心点
    private var arrowCornerCenter: CGPoint {
        
        let disdanceBetweenPosition = sqrt(arrowCornerRadius * arrowCornerRadius * 2)
        let arrowCornerCenterY: CGFloat
        
        switch (arrowDirection) {
        case .down:
            arrowCornerCenterY = arrowVertexPosition.y - disdanceBetweenPosition;
        case .up:
            arrowCornerCenterY = arrowVertexPosition.y + disdanceBetweenPosition;
        }
        
        return CGPoint(x: arrowVertexPosition.x, y: arrowCornerCenterY)
    }
    
    /// 顶部偏移
    private var topOffset: CGFloat {
        switch (arrowDirection) {
        case .up:
            return arrowSize.height
        default:
            return 0
        }
    }
    
    /// 底部偏移
    private var bottomOffset: CGFloat {
        switch (arrowDirection) {
        case .down:
            return arrowSize.height
        default:
            return 0
        }
    }
    
    /// 隐藏动画完成的处理
    private var hideAnimationCompletionHandler: (() -> Void)?
    
    
    // MARK: - Life Cycle Methods
    
    public override init(contentView: UIView) {
        super.init(contentView: contentView, contentInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.backgroundColor = UIColor(white: 60/255.0, alpha: 1.0)
    }
    
    public override init(contentView: UIView, contentInsets: UIEdgeInsets) {
        super.init(contentView: contentView, contentInsets: contentInsets)
        self.backgroundColor = UIColor(white: 60/255.0, alpha: 1.0)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(white: 60/255.0, alpha: 1.0)
    }
    
    
    // MARK: - Overrides
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    open override var contentInsetsOffset: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: arrowDirection == .up ? arrowHeight : 0,
                                left: 0,
                                bottom: arrowDirection == .down ? arrowHeight : 0,
                                right: 0)
        }
        set {
            switch arrowDirection {
            case .down:
                arrowHeight = newValue.bottom
            case .up:
                arrowHeight = newValue.top
            }
        }
    }
    
    open override func setupMaskLayer(_ maskLayer: CAShapeLayer) {
        
        // 四个角圆弧中心
        let topLeftCornerCenter     = CGPoint(x: cornerRadius, y: cornerRadius + topOffset)
        let topRightCornerCenter    = CGPoint(x: bounds.size.width-cornerRadius, y: cornerRadius + topOffset)
        let bottomLeftCornerCenter  = CGPoint(x: cornerRadius, y: bounds.size.height - cornerRadius - bottomOffset)
        let bottomRightCornerCenter = CGPoint(x: bounds.size.width-cornerRadius, y: bounds.size.height - cornerRadius - bottomOffset)
        
        let arrowControlTangentLength = sqrt((arrowCornerRadius*2) * (arrowCornerRadius*2) * 2) - arrowCornerRadius*2
        
        // 箭头左边控制点圆弧中心
        let arrowLeftControlCornerCenterX = arrowVertexPosition.x - arrowSize.width/2.0 - arrowControlTangentLength
        let arrowLeftControlCornerCenterY: CGFloat
        switch arrowDirection {
        case .down:
            arrowLeftControlCornerCenterY = bottomLeftCornerCenter.y + cornerRadius + arrowCornerRadius*2
        case .up:
            arrowLeftControlCornerCenterY = topLeftCornerCenter.y - cornerRadius - arrowCornerRadius*2
        }
        let arrowLeftControlCornerCenter = CGPoint(x: arrowLeftControlCornerCenterX, y: arrowLeftControlCornerCenterY)
        
        // 箭头右边控制点圆弧中心
        let arrowRightControlCornerCenterX = arrowVertexPosition.x + arrowSize.width/2.0 + arrowControlTangentLength
        let arrowRightControlCornerCenterY: CGFloat
        switch arrowDirection {
        case .down:
            arrowRightControlCornerCenterY = bottomRightCornerCenter.y + cornerRadius + arrowCornerRadius*2
        case .up:
            arrowRightControlCornerCenterY = topLeftCornerCenter.y - cornerRadius - arrowCornerRadius*2
        }
        let arrowRightControlCornerCenter = CGPoint(x: arrowRightControlCornerCenterX, y: arrowRightControlCornerCenterY)
        
        // 箭头圆弧位置偏移
        let arrowCornerRadiusOffset = sqrt(arrowCornerRadius*arrowCornerRadius)/2.0
        let arrowControlOffset = sqrt(arrowControlTangentLength * arrowControlTangentLength)/2.0
        
        // 绘制形状
        let path = UIBezierPath()
        
        // 绘制顶部
        path.move(to: CGPoint(x: topLeftCornerCenter.x, y: topRightCornerCenter.y-cornerRadius))
        
        if case .up = arrowDirection {
            path.addLine(to: CGPoint(x: arrowLeftControlCornerCenter.x, y: topLeftCornerCenter.y-cornerRadius))
            
            // 绘制箭头
            path.addArc(withCenter: arrowLeftControlCornerCenter, radius: arrowCornerRadius*2, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi/4.0, clockwise: false)
            path.addLine(to: CGPoint(x: arrowVertexPosition.x-arrowCornerRadiusOffset, y: arrowVertexPosition.y+arrowCornerRadiusOffset))
            path.addArc(withCenter: arrowCornerCenter, radius: arrowCornerRadius, startAngle: CGFloat.pi/4.0*5, endAngle: CGFloat.pi/4.0*7, clockwise: true)
            path.addLine(to: CGPoint(x: arrowVertexPosition.x + arrowSize.width/2.0 - arrowControlOffset, y: topRightCornerCenter.y-cornerRadius-arrowControlOffset))
            path.addArc(withCenter: arrowRightControlCornerCenter, radius: arrowCornerRadius*2, startAngle: CGFloat.pi/4.0*3, endAngle: CGFloat.pi/2.0, clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: topRightCornerCenter.x, y: topRightCornerCenter.y-cornerRadius))
        path.addArc(withCenter: topRightCornerCenter, radius: cornerRadius, startAngle: CGFloat.pi/2.0 * 3, endAngle: 0, clockwise: true)
        
        // 绘制右边
        path.addLine(to: CGPoint(x: bottomRightCornerCenter.x + cornerRadius, y: bottomRightCornerCenter.y))
        path.addArc(withCenter: bottomRightCornerCenter, radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi/2.0, clockwise: true)
                
        // 绘制底部
        if case .down = arrowDirection {
            
            path.addLine(to: CGPoint(x: arrowRightControlCornerCenter.x, y: bottomRightCornerCenter.y + cornerRadius))
            
            // 绘制箭头
            path.addArc(withCenter: arrowRightControlCornerCenter, radius: arrowCornerRadius*2, startAngle: CGFloat.pi/2.0*3, endAngle: CGFloat.pi/4.0*5, clockwise: false)
            path.addLine(to: CGPoint(x: arrowVertexPosition.x+arrowCornerRadiusOffset, y: arrowVertexPosition.y-arrowCornerRadiusOffset))
            path.addArc(withCenter: arrowCornerCenter, radius: arrowCornerRadius, startAngle: CGFloat.pi/4.0, endAngle: CGFloat.pi/4.0*3, clockwise: true)
            path.addLine(to: CGPoint(x: arrowVertexPosition.x - arrowSize.width/2.0 + arrowControlOffset, y: bottomLeftCornerCenter.y+cornerRadius+arrowControlOffset))
            path.addArc(withCenter: arrowLeftControlCornerCenter, radius: arrowCornerRadius*2, startAngle: CGFloat.pi/4.0*7, endAngle: CGFloat.pi/2.0*3, clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: bottomLeftCornerCenter.x, y: bottomLeftCornerCenter.y+cornerRadius))
        path.addArc(withCenter: bottomLeftCornerCenter, radius: cornerRadius, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: true)
        
        // 绘制左边
        path.addLine(to: CGPoint(x: topLeftCornerCenter.x-cornerRadius, y: topLeftCornerCenter.y))
        path.addArc(withCenter: topLeftCornerCenter, radius: cornerRadius, startAngle: CGFloat.pi/4.0*3, endAngle: 0, clockwise: true)
        
        path.close()
        
        maskLayer.path = path.cgPath
    }
}

extension KBPopupView {
    
    /// 显示弹窗，采用默认显示动画
    /// - Parameter containerView: 容器的View
    @objc
    public func show(in containerView: UIView) {
        show(in: containerView) { popupView in
                                            
            // 默认显示动画
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue             = 0
            animation.toValue               = 1.0
            animation.duration              = 0.15
            animation.timingFunction        = CAMediaTimingFunction(name : .easeInEaseOut)
            animation.fillMode              = .forwards
            animation.isRemovedOnCompletion = false
                        
            popupView.layer.add(animation, forKey: "KBPopupView.Animation.show")
        }
    }
    
    /// 显示弹窗
    /// - Parameters:
    ///   - containerView: 容器视图
    ///   - animationSetup: 显示动画配置
    @objc
    public func show(in containerView: UIView, animationSetup: ((KBPopupView) -> Void)?) {
        
        let animated = (containerView != self.superview)
        if animated {
            self.layer.opacity = 0;
        } else {
            self.layer.opacity = 1;
        }
        
        addToContainer(containerView)
        
        if self.superview == nil {
            return
        }
        
        if animated {
            animationSetup?(self)
        }
    }
    
    /// 隐藏弹窗，采用默认隐藏动画
    @objc
    public func hide() {
        
        hide { popupView, completionHandler in
            
            self.hideAnimationCompletionHandler = completionHandler
            
            // 默认隐藏动画
            let animation = CASpringAnimation(keyPath: "opacity")
            animation.fromValue             = 1.0
            animation.toValue               = 0
            animation.duration              = 0.15
            animation.timingFunction        = CAMediaTimingFunction(name : .easeInEaseOut)
            animation.fillMode              = .forwards
            animation.isRemovedOnCompletion = false
            animation.delegate              = self
                        
            popupView.layer.add(animation, forKey: "KBPopupView.Animation.hide")
        }
    }
    
    /// 因此动画
    /// - Parameter animationSetup: 隐藏动画配置
    @objc
    public func hide(animationSetup: ((KBPopupView, (() -> Void)?) -> Void)?) {
        if let animSetup = animationSetup {
            animSetup(self) { [weak self] in
                self?.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
}

extension KBPopupView: CAAnimationDelegate {
    
    /// 动画完成
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if self.layer.animation(forKey: "KBPopupView.Animation.hide") == anim {
            hideAnimationCompletionHandler?()
        }
    }
}

// MARK: - Helper Methods
extension KBPopupView {
    
    /// 添加弹窗视图到容器上
    func addToContainer(_ containerView: UIView) {
        var sourceViewFrame = CGRect.zero
        if let sourceView = self.sourceView {
            sourceViewFrame = containerView.convert(sourceView.frame, from: sourceView.superview)
        } else if sourceFrame != .zero {
            sourceViewFrame = sourceFrame
        }
        
        guard sourceViewFrame != .zero else {
            return
        }
            
        self.bounds = CGRect(x: 0, y: 0, width: self.intrinsicContentSize.width, height: self.intrinsicContentSize.height)
        
        if self.superview != containerView {
            containerView.addSubview(self)
        }
        
        let positionX: CGFloat
        let positionY: CGFloat
                    
        // 计算x轴位置和箭头位置
        if sourceViewFrame.midX - (self.bounds.width / 2.0) < margin.left {
            arrowVertexXOffset = sourceViewFrame.midX - self.bounds.midX - margin.left
            positionX = margin.left + arrowVertexPosition.x
        } else if sourceViewFrame.midX + (self.bounds.width / 2.0) > (containerView.bounds.width - margin.right) {
            arrowVertexXOffset = sourceViewFrame.midX - (containerView.bounds.width - self.bounds.midX - margin.right)
            positionX = containerView.bounds.width - margin.right - (bounds.width - arrowVertexPosition.x)
        } else {
            arrowVertexXOffset = 0
            positionX = sourceViewFrame.midX
        }
        
        if (sourceViewFrame.origin.y - self.bounds.height > margin.top) { // 弹窗在上，箭头朝下
            self.arrowDirection = .down
            positionY = sourceViewFrame.origin.y
        } else { // 弹窗在下，箭头朝上
            self.arrowDirection = .up
            positionY = sourceViewFrame.origin.y + sourceViewFrame.height
        }
        
        let anchorX: CGFloat = arrowVertexPosition.x / bounds.width;
        let anchorY: CGFloat = arrowDirection == .down ? 1 : 0
        
        layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        layer.position = CGPoint(x: positionX, y: positionY)
    }
}

// MARK: - Types
public extension KBPopupView {
    
    /// 箭头方向
    @objc(KBPopupArrowDirection)
    enum ArrowDirection: Int {
        /// 箭头朝下
        case down = 0
        /// 箭头朝上
        case up = 1
    }
}
