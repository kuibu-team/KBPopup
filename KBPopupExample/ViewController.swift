//
//  ViewController.swift
//  KBPopupExample
//
//  Created by 张鹏 on 2021/6/9.
//

import UIKit
import KBPopup

class ViewController: UIViewController {
    
    lazy var popupView: KBPopupView = {
        let myView = UIView(frame: .zero)
        myView.backgroundColor = .red

        let popupView = KBPopupView(contentView: myView)
        popupView.contentSize = CGSize(width: 180, height: 66)
        popupView.margin = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        return popupView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap(_:))))
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if let buttonFrame = button.window?.convert(button.frame, from: button.superview) {
            popupView.sourceFrame = buttonFrame
        }
        
        popupView.show(in: self.view)
    }
    
    @objc
    func backgroundDidTap(_ sender: Any?) {
        self.popupView.hide()
    }
    
    func testPopupView() {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        myView.backgroundColor = .red
        myView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        let popupView = KBPopupView(contentView: myView)

        self.view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        popupView.backgroundColor = .lightGray

        print(popupView.contentInsetsOffset)
        
        self.popupView = popupView
    }
    
}

