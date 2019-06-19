//
//  ErrorPresentable.swift
//  notes
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol ErrorPresentable {
    func show(error: Error, text: String?, on navigationController: UINavigationController?)
}

extension ErrorPresentable {
    func show(error: Error, text: String?, on navigationController: UINavigationController?) {
        let title = text ?? L10n.generalAlertTitle
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.generalOk, style: .default, handler: { _ in
            navigationController?.topViewController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        navigationController?.visibleViewController?.present(alertController, animated: true)
    }
}
