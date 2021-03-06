//
//  SwipeController.swift
//  Clique
//
//  Created by Phil Hawkins on 12/9/17.
//  Copyright © 2017 Phil Hawkins. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class SwipeController: SwipeableTabBarController {
    
    //MARK: - properties
    
    @IBInspectable var startindex: Int = 1
    var provisioned = false
    
    //MARK: - lifecycle stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeAnimation(type: SwipeAnimationType.none)
        setDiagonalSwipe(enabled: true)
        
        swipe = self
        
        provision()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setSwipeAnimation(type: SwipeAnimationType.sideBySide)
    }
    
    //MARK: - actions
    
    func provision() {
        if provisioned { return }
        
        Identity.wave()
        Settings.update()
        
        let controllers = viewControllers!
        
        controllers.forEach { let _ = $0.view }
        
        let bronav = controllers[0] as! UINavigationController
        bronav.viewControllers.forEach { let _ = $0.view }
        bro = bronav.visibleViewController as! BrowseViewController
        np = controllers[1] as! NowPlayingViewController
        let qnav = controllers[2] as! UINavigationController
        bronav.viewControllers.forEach { let _ = $0.view }
        q = qnav.visibleViewController as! QueueViewController
                
        bro.user = Identity.me
        q.user = Identity.me
        
        selectedViewController = controllers[startindex]
        
        provisioned = true
    }
}
