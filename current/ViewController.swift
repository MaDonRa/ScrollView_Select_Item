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

    internal var CurrentIndex : CGFloat = 0

    internal var SpacePerItem : CGFloat = 15
    internal var ItemPerPage : CGFloat = 3
    internal var TotalItem : CGFloat = 30
    internal var AddBackgroundSizeWhenSelected = CGSize(width: 30, height: 30)
    internal var BackgroundViewSize : CGSize = CGSize(width: (ScreenSize.SCREEN_WIDTH / 3) - 30, height: 150)
    
    private var SetCurrentIndexItem : CGFloat {
        get {
            return CurrentIndex
        }
        set {
            MyScrollView.setContentOffset(CGPoint(x: ((MyScrollView.frame.size.width/ItemPerPage) * newValue), y: 0), animated: true)
        }
    }
    private var Scrolling : Bool = false
    private var SelectedBackgroundSize : CGSize {
        get {
            return CGSize(width: BackgroundViewSize.width + AddBackgroundSizeWhenSelected.width, height: BackgroundViewSize.height + AddBackgroundSizeWhenSelected.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var CounterImage:CGFloat = 1
        for Data in 1...Int(TotalItem) {
            let ImageView = UIView(frame: CGRect(x: ((ScreenSize.SCREEN_WIDTH/ItemPerPage) * CounterImage) + SpacePerItem, y: 100 - (BackgroundViewSize.height/2), width: BackgroundViewSize.width, height: BackgroundViewSize.height))
         
            if Data == Int(SetCurrentIndexItem+1) {
                ImageView.transform = CGAffineTransform(translationX: -(AddBackgroundSizeWhenSelected.width/2), y: -(AddBackgroundSizeWhenSelected.height/2))
                ImageView.frame.size = SelectedBackgroundSize
                ImageView.backgroundColor = UIColor.red
            } else {
                ImageView.backgroundColor = UIColor.yellow
            }
            
            ImageView.tag = Data
        
            let Label = UILabel(frame: CGRect(x: 0 , y: 0, width: ImageView.frame.size.width, height: ImageView.frame.size.height))
            Label.textAlignment = .center
            Label.text = "\(Data)"
            Label.numberOfLines = 0
            Label.font = UIFont.systemFont(ofSize: ScreenSize.SCREEN_HEIGHT_AutoLayout * 30)
            ImageView.addSubview(Label)
            
            MyScrollView.addSubview(ImageView)
    
            CounterImage += 1
        }
        MyScrollView.contentSize = CGSize(width: (((ScreenSize.SCREEN_WIDTH/ItemPerPage)-SpacePerItem) * (CounterImage+1)) + (SpacePerItem*(CounterImage+1)), height: 200)
        
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
        
        CurrentIndex = CGFloat(Int(scrollView.contentOffset.x / ((scrollView.frame.size.width/ItemPerPage)-(SpacePerItem/3))))
        if CurrentIndex >= TotalItem { CurrentIndex -= 1 }
   
        for UI in scrollView.subviews {
           //if CurrentIndex >= TotalItem { CurrentIndex -= 1 }
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.SelectedItem) , userInfo: nil, repeats: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        SelectedItem()
    }
    
    @objc private func SelectedItem() {
        print("Current Index \(CurrentIndex)")
        Scrolling = false
        if CurrentIndex >= TotalItem { CurrentIndex -= 1 }
        MyScrollView.setContentOffset(CGPoint(x: ((MyScrollView.frame.size.width/ItemPerPage) * CurrentIndex), y: 0), animated: true)
    }
}
