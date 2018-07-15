//
//  ViewController.swift
//  current
//
//  Created by Sakkaphong Luaengvilai on 12/7/2561 BE.
//  Copyright © 2561 Sakkaphong Luaengvilai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MyScrollView: UIScrollView!

    internal var MyScrollViewSize : CGSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: 200)
    internal var CurrentIndex : CGFloat = 1
    internal var SpacePerItem : CGFloat = 15
    internal var ItemPerPage : CGFloat = 3
    internal var TotalItem : CGFloat = 30
    internal var AddBackgroundSizeWhenSelected = CGSize(width: 30, height: 30)
    
    //Private
    internal var BackgroundViewSize : CGSize {
        get {
            return CGSize(width: (MyScrollViewSize.width / 3) - 30, height: MyScrollViewSize.height - 60)
        }
    }
    internal var SetCurrentIndexItem : CGFloat {
        get {
            return CurrentIndex
        }
        set {
            CurrentIndex = newValue
            MyScrollView.setContentOffset(CGPoint(x: ((MyScrollViewSize.width/ItemPerPage) * newValue), y: 0), animated: true)
            SetupSelectedItem(scrollView : MyScrollView)
        }
    }
    internal var Scrolling : Bool = false
    internal var SelectedBackgroundSize : CGSize {
        get {
            return CGSize(width: BackgroundViewSize.width + AddBackgroundSizeWhenSelected.width, height: BackgroundViewSize.height + AddBackgroundSizeWhenSelected.height)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var CounterView:CGFloat = 1
        for Data in 1...Int(TotalItem) {
            let BackgroundItem = UIView(frame: CGRect(x: ((MyScrollViewSize.width/ItemPerPage) * CounterView) + SpacePerItem, y: (MyScrollViewSize.height/2) - (BackgroundViewSize.height/2), width: BackgroundViewSize.width, height: BackgroundViewSize.height))

            BackgroundItem.isUserInteractionEnabled = true
            BackgroundItem.tag = Data
            BackgroundItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.PrepareSelectItem(_:))))
            
            let Label = UILabel(frame: CGRect(x: 0 , y: 0, width: BackgroundItem.frame.size.width, height: BackgroundItem.frame.size.height))
            Label.textAlignment = .center
            Label.text = "\(Data)"
            Label.numberOfLines = 0
            Label.font = UIFont.systemFont(ofSize: ScreenSize.SCREEN_HEIGHT_AutoLayout * 30)
            BackgroundItem.addSubview(Label)
            
            MyScrollView.addSubview(BackgroundItem)
            
            CounterView += 1
        }
        MyScrollView.contentSize = CGSize(width: (((MyScrollViewSize.width/ItemPerPage)-SpacePerItem) * (CounterView+1)) + (SpacePerItem*(CounterView+1)), height: MyScrollViewSize.height - 10)
        SetCurrentIndexItem = CurrentIndex
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SetCurrentIndexItem = CurrentIndex
    }
}

extension ViewController : UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        Scrolling = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        guard Scrolling else {
            return
        }
        
        CurrentIndex = CGFloat(Int(scrollView.contentOffset.x / ((scrollView.frame.size.width/ItemPerPage)-((SpacePerItem/3)-(TotalItem/10)))))
        if CurrentIndex >= TotalItem { CurrentIndex -= 1 }
        
        SetupSelectedItem(scrollView : scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.SelectedItem) , userInfo: nil, repeats: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        SelectedItem()
    }
    
    internal func SetupSelectedItem(scrollView: UIScrollView) {
        for UI in scrollView.subviews {
            if Int(CurrentIndex+1) == UI.tag {
                UI.backgroundColor = UIColor.red
                UI.transform = CGAffineTransform(translationX: -(AddBackgroundSizeWhenSelected.width/2), y: -(AddBackgroundSizeWhenSelected.height/2))
                UI.frame.size = SelectedBackgroundSize
                for a in UI.subviews {
                    if let label = a as? UILabel {
                        label.textColor = UIColor.yellow
                        label.frame.size = SelectedBackgroundSize
                    }
                }
            } else if UI.tag >= 1 {
                UI.transform = CGAffineTransform.identity
                UI.backgroundColor = UIColor.yellow
                UI.frame.size = BackgroundViewSize
                for a in UI.subviews {
                    if let label = a as? UILabel {
                        label.textColor = UIColor.black
                        label.frame.size = BackgroundViewSize
                    }
                }
            }
        }
    }
    
    @objc private func PrepareSelectItem(_ sender : UIGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        SetCurrentIndexItem = CGFloat(index-1)
        SelectedItem()
    }
    
    @objc private func SelectedItem() {
        print("Current Index \(CurrentIndex)")
        Scrolling = false
        if CurrentIndex >= TotalItem { CurrentIndex -= 1 }
        SetCurrentIndexItem = CurrentIndex
    }
}
