//
//  ListViewController.swift
//  KBPopupExample
//
//  Created by 张鹏 on 2021/6/17.
//

import UIKit
import KBPopup

class ListViewController: UIViewController {
    
    lazy var popupView: KBPopupView = {
        let myView = UIView(frame: .zero)
        myView.backgroundColor = .red

        let popupView = KBPopupView(contentView: myView)
        popupView.contentSize = CGSize(width: 180, height: 66)
        popupView.margin = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        return popupView
    }()

    @IBOutlet weak var listView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
//        popupView.sourceView = collectionView.cellForItem(at: indexPath)
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        popupView.sourceFrame = cell.frame
        popupView.show(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat.random(in: 100...300), height: CGFloat.random(in: 600...900))
    }
}
