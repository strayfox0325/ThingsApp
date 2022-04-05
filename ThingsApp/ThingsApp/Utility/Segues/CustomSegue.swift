//
//  CustomSegue.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 29.3.22..
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        scaleTransition()
    }
    
    func scaleTransition() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        destination.modalPresentationStyle = .fullScreen
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        toViewController.view.alpha = 0.0
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.alpha = 1.0
        }, completion: { done in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}
