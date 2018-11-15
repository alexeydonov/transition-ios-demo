//
//  UINavigationController+Transition.swift
//  Transition
//
//  Created by Alexey Donov on 15.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import UIKit

extension UINavigationController {
    static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"
    
    var transitionCoordinatorHelper: TransitionCoordinator? {
        return objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionCoordinator
    }
    
    func addCustomTransitioning() {
        var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionCoordinator
        
        guard object == nil else {
            return
        }
        
        object = TransitionCoordinator()
        let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)
        
        delegate = object
        
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
    }
    
    @objc private func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            transitionCoordinatorHelper?.interactionController = nil
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        switch gestureRecognizer.state {
        case .began:
            transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
            
        case .changed:
            transitionCoordinatorHelper?.interactionController?.update(percent)
            
        case .ended:
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                transitionCoordinatorHelper?.interactionController?.finish()
            }
            else {
                transitionCoordinatorHelper?.interactionController?.cancel()
            }
            transitionCoordinatorHelper?.interactionController = nil
            
        default: break
        }
    }
}
