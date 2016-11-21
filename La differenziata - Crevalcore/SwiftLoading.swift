//
//  SwiftLoading.swift
//  La differenziata - Crevalcore
//
//  Created by Francesco Galasso on 13/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

//
//  SwiftLoading.Swift
//  LoveYourSelfie
//
//  Created by Francesco Galasso on 07/03/16.
//  Copyright © 2016 Francesco Galasso. All rights reserved.
//

import UIKit

class SwiftLoading {
    
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showLoading() {
        
        let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor .darkGrayColor()
        self.loadingView.alpha = 0.6
        
        win.addSubview(self.loadingView)
        
        activityIndicator.frame = CGRectMake(0, 0, win.frame.width/5, win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = self.loadingView.center
        
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
    func hideLoading(){
        UIView.animateWithDuration(0.0, delay: 0.0, options: .CurveEaseOut, animations: {
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
            }, completion: { finished in
                self.activityIndicator.removeFromSuperview()
                self.loadingView.removeFromSuperview()
                let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
                let removeView  = win.viewWithTag(1)
                removeView?.removeFromSuperview()
        })
    }
}

