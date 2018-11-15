//
//  TransitionAnimator.swift
//  Transition
//
//  Created by Alexey Donov on 15.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import UIKit

final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        
        var fromFrame = fromVC.view.frame
        let toFrame = fromVC.view.frame
        
        var animatingImageView: UIImageView?
        var sourceImageView: UIImageView?
        var targetImageView: UIImageView?
        var imageViewFinish: CGRect?

        if presenting {
            if let tvc = fromVC as? TableViewController,
                let ivc = toVC as? ImageViewController,
                let iv = tvc.segueImageView {
                sourceImageView = iv
                targetImageView = ivc.imageView
                
                animatingImageView = UIImageView()
                animatingImageView!.image = sourceImageView!.image
                animatingImageView!.contentMode = .scaleAspectFill
                animatingImageView!.clipsToBounds = true
                animatingImageView!.frame = container.convert(iv.frame, from: iv.superview)

                imageViewFinish = toFrame

                targetImageView?.isHidden = true
                container.addSubview(toVC.view)
                
                container.addSubview(animatingImageView!)
                sourceImageView!.isHidden = true

                toVC.view.frame = fromFrame.offsetBy(dx: fromFrame.size.width, dy: 0)
                fromFrame = fromFrame.offsetBy(dx: -fromFrame.size.width / 2, dy: 0)
            }
        }
        else {
            if let ivc = fromVC as? ImageViewController,
                let tvc = toVC as? TableViewController,
                let iv = tvc.segueImageView {
                sourceImageView = ivc.imageView
                targetImageView = iv
                
                animatingImageView = UIImageView()
                animatingImageView!.image = sourceImageView!.image
                animatingImageView!.contentMode = .scaleAspectFill
                animatingImageView!.clipsToBounds = true
                animatingImageView!.frame = fromFrame
                
                imageViewFinish = container.convert(iv.frame, from: iv.superview)
                
                targetImageView?.isHidden = true
                container.insertSubview(toVC.view, belowSubview: fromVC.view)

                container.addSubview(animatingImageView!)
                sourceImageView!.isHidden = true
                
                toVC.view.frame = fromFrame.offsetBy(dx: -fromFrame.size.width / 2, dy: 0)
                fromFrame = fromFrame.offsetBy(dx: fromFrame.size.width, dy: 0)
            }
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                fromVC.view.frame = fromFrame
                toVC.view.frame = toFrame
            }
            
            if let imageView = animatingImageView, let finish = imageViewFinish {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                    imageView.frame = finish
                }
            }
        }, completion: { finished in
            if !transitionContext.transitionWasCancelled {
                targetImageView?.isHidden = false
            }
            else {
                sourceImageView?.isHidden = false
            }
            
            animatingImageView?.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
