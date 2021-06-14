# KBDecorationView

装饰视图，用于装饰内容视图，KBDecorationView主要的功能是提供一个装饰框，可以指定装饰框型的形状，通过蒙版来实现，绘制蒙版的形状即可指定装饰框的形状

[TOC]



## 导入

### CocoaPods

在`Podfile`文件中加入

```ruby
pod 'KBDecorationView', '~> 1.5.0'
```



## 使用

使用非常简单

```swift
let myView = ...
let decorationView = KBDecorationView(contentView: myView)
view.addSubview(decorationView)
```

> KBDecorationView使用AutoLayout

设置内容的内边距

```swift
decorationView.contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
```

或者在初始化时指定内边距

```swift
let decorationView = KBDecorationView(contentView: myView, contentInsets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
```

默认的装饰框是一个圆角矩形，有两种方式来自定义装饰框的形状

第一种是继承KBDecorationView，然后重写`setupMaskLayer(_:)`方法

```swift
class MyView: KBDecorationView {            
  
    var cornerRadius: CGFloat = 8
    
    override func setupMaskLayer(_ maskLayer: CAShapeLayer) {
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}
```

⚠️ 第一种方法只适用于Swift，Objective-C不能继承Swift的类

第二种方法是通过`maskLayerSetupHandler` 闭包，`maskLayerSetupHandler`的优先级比`setupMaskLayer`优先级高

```swift
decorationView.maskLayerSetupHandler = { (maskLayer) in		 
		maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath;
}
```



## LICENSE

此项目采用**MIT**开源协议，[点击查看详情](LICENSE)

