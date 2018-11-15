//
//  TransitionCoordinator.swift
//  Transition
//
//  Created by Alexey Donov on 15.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import UIKit

final class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    static let shared = TransitionCoordinator()
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push: return TransitionAnimator(presenting: true)
        case .pop: return TransitionAnimator(presenting: false)
        default: return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
