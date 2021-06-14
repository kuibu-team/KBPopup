//
//  KBDecorationView.swift
//  KBDecorationView
//
//  Created by 张鹏 on 2021/6/9.
//

import UIKit

/// 装饰视图
@objc
open class KBDecorationView: UIView {
    
    // MARK: - Public Properties
    
    /// 内容视图
    @objc
    public private(set) var contentView: UIView
    
    /// 内容尺寸
    @objc
    public var contentSize: CGSize = .zero
    
    /// 内容内边距
    @objc
    open var contentInsets: UIEdgeInsets {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// 内容内边距的偏移，方便子类进行扩展
    @objc
    open var contentInsetsOffset: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// 配置遮罩层的处理，与`setupMaskLayer`方法二选一，优先采用`maskLayerSetupHandler`
    @objc
    public var maskLayerSetupHandler: ((_ maskLayer: CAShapeLayer) -> Void)?
    
    
    // MARK: - Private Properties
    
    /// 遮罩层
    private var maskLayer = CAShapeLayer()
    
    /// 内容边距的约束
    private var contentViewEdgeConstraints = [NSLayoutConstraint]()
    
    
    // MARK: - Life Cycle Methods
    
    /// 初始化方法
    /// - Parameter contentView: 内容视图
    @objc
    public init(contentView: UIView) {
        self.contentView   = contentView
        self.contentInsets = UIEdgeInsets(top : 10, left : 15, bottom : 10, right : 15)
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    /// 初始化方法
    /// - Parameter contentView: 内容视图
    /// - Parameter contentInsets: 内容边距
    @objc
    public init(contentView: UIView, contentInsets: UIEdgeInsets) {
        self.contentView   = contentView
        self.contentInsets = contentInsets
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    /// 初始化方法
    public required init?(coder: NSCoder) {
        self.contentView         = UIView()
        self.contentInsets       = UIEdgeInsets(top : 10, left : 10, bottom : 10, right : 10)
        self.contentInsetsOffset = .zero
        super.init(coder: coder)
        
        setupSubviews()
    }
    
    /// 页面布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        relayoutContentView()
        
        if let setupHandler = maskLayerSetupHandler {
            setupHandler(maskLayer)
        } else {
            setupMaskLayer(maskLayer)
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        
        let finalInsets = UIEdgeInsets(top: contentInsets.top + contentInsetsOffset.top,
                                       left: contentInsets.left + contentInsetsOffset.left,
                                       bottom: contentInsets.bottom + contentInsetsOffset.bottom,
                                       right: contentInsets.right + contentInsetsOffset.right)
        
        var contentSize = self.contentSize
        if contentSize == .zero {
            contentSize = contentView.intrinsicContentSize
        }
        
        return CGSize(width: contentSize.width + finalInsets.left + finalInsets.right,
                      height: contentSize.height + finalInsets.top + finalInsets.bottom)
    }
    
    
    // MARK: - Subview Hooks
    
    /// 配置遮罩层
    @objc
    open func setupMaskLayer(_ maskLayer: CAShapeLayer) {
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height/8.0).cgPath
    }
}

// MARK: - Helper Methods
extension KBDecorationView {
    
    /// 配置子视图
    func setupSubviews() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.618)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        maskLayer.backgroundColor = UIColor.black.cgColor
        self.layer.mask = maskLayer
    }
    
    /// 重新布局contentView
    private func relayoutContentView() {
        
        let finalInsets = UIEdgeInsets(top: contentInsets.top + contentInsetsOffset.top,
                                       left: contentInsets.left + contentInsetsOffset.left,
                                       bottom: contentInsets.bottom + contentInsetsOffset.bottom,
                                       right: contentInsets.right + contentInsetsOffset.right)
        
        contentView.frame = CGRect(x: finalInsets.left,
                                   y: finalInsets.top,
                                   width: bounds.size.width - finalInsets.left - finalInsets.right,
                                   height: bounds.size.height - finalInsets.top - finalInsets.bottom)
    }
}
