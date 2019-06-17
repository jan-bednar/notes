//
//  DetailViewController.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewControllerDidFinish(text: String)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    private var originalText: String?
    
    @IBOutlet private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        let barItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.setRightBarButton(barItem, animated: false)
        textView.text = originalText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func set(originalText: String) {
        self.originalText = originalText
    }
    
    @objc private func doneAction() {
        delegate?.detailViewControllerDidFinish(text: textView.text)
    }
}
