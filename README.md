# KBPopup

iOS带箭头的起泡弹窗

[TOC]

## 导入

### CocoaPods

在`Podfile`文件中加入

```ruby
pod 'KBPopup', '~> 1.0.1'
```



## 使用

KBPopupView继承自[KBDecorationView](https://github.com/kuibu-team/KBDecorationView)，实现了带箭头的圆角矩形边框

KBPopupView使用非常简单，只需要指定内容视图和内容视图的尺寸，然后调用`show(in:)`方法进行显示即可

```swift
import KBPopup

let myContentView = ...
let popupView = KBPopupView(contentView: myContentView)
popupView.contentSize = myContentViewSize
popupView.sourceView = button

popupView.show(in: self.view)
```

如果内容视图支持`intrinsicContentSize`（例如UILabel），则可以不指定`contentSize`属性

KBPopupView支持以下特性：

- 指定边框的箭头高度、箭头圆角
- 指定边框的圆角半径
- 指定弹窗的外边距
- 指定弹窗的来源视图或来源位置
- KBDecorationView携带的特性

### 指定边框的箭头高度、箭头圆角

KBPopupView的箭头图形绘制参考了[FTPopOverMenu](https://github.com/liufengting/FTPopOverMenu)的方案，KBPopupView提供了指定箭头高度和圆角半径的接口

```swift
popupView.arrowHeight = 20 				// 默认值是10
popupView.arrowCornerRadius = 6		// 默认值是3
```

### 指定边框的圆角半径

```swift
popupView.popupView = 10 // 默认值是8
```

### 指定弹窗的外边距

```swift
popupView.margin = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) // 默认值是20
```

### 指定弹窗的来源视图或来源位置

KBPopupView会根据sourceView或sourceFrame来自动计算显示的位置和箭头的方向

```swift
popupView.sourceView = button
// 或
if let buttonFrame = button.window?.convert(button.frame, from: button.superview) {
    popupView.sourceFrame = buttonFrame
}
```

sourceFrame的优先级高于sourceView，指定sourceFrame时需要转化为目标位置在window上的位置

### KBDecorationView携带的特性

KBDecorationView自带了几个非常有用的特性：

- contentSize：内容尺寸
- contentInsets：内容与边框的边距

```swift
popupView.contentSize = CGSize(width: 180, height: 66)
popupView.contentInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) //默认值是10
```



## LICENSE

此项目采用**MIT**开源协议，[点击查看详情](LICENSE)

