//
//  HasLoading.swift
//  notes
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import PromiseKit
import UIKit

protocol HasLoading {
    func showLoading(in viewController: UIViewController) -> (Guarantee<Void>, LoadingViewController)
    func remove(loadingViewController: LoadingViewController) -> Guarantee<Void>
}

var animationDuration: TimeInterval = 0.3

extension HasLoading {
    func showLoading(in viewController: UIViewController) -> (Guarantee<Void>, LoadingViewController) {
        return showLoading(in: viewController, animated: true)
    }
    
    func showLoading(in viewController: UIViewController, animated: Bool) -> (Guarantee<Void>, LoadingViewController) {
        let loadingViewController = LoadingViewController()
        let animation = Guarantee<Void> { seal in
            loadingViewController.willMove(toParent: viewController)
            viewController.addChild(loadingViewController)
            
            UIView.transition(with: viewController.view, duration: animationDuration, options: [.transitionCrossDissolve], animations: {
                viewController.view.addSubview(loadingViewController.view)
            }) { _ in
                loadingViewController.didMove(toParent: viewController)
                seal(())
            }
        }
        return (animation, loadingViewController)
    }
    
    @discardableResult
    func remove(loadingViewController: LoadingViewController) -> Guarantee<Void> {
        guard let superview = loadingViewController.view.superview else {
            return Guarantee()
        }
        
        loadingViewController.willMove(toParent: nil)
        let animation = Guarantee<Void> { seal in
            UIView.transition(with: superview, duration: animationDuration, options: [.transitionCrossDissolve], animations: {
                loadingViewController.view.removeFromSuperview()
            }) { _ in
                loadingViewController.didMove(toParent: nil)
                seal(())
            }
        }
        return animation
    }
}
