//
//  ContainerViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-12-21.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        var centerNavigationController: UINavigationController!
        var centerViewController: CenterViewController!
        super.viewDidLoad()
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
/*    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
    }*/
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
    
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
    }
    
    func toggleRightPanel() {
    }
    
    func addLeftPanelViewController() {
    }
    
    func addRightPanelViewController() {
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
    }
    
    func animateRightPanel(shouldExpand shouldExpand: Bool) {
    }
    
}
