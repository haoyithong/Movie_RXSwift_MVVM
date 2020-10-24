//
//  BaseVC.swift
//  movie
//
//  Created by Thong Hao Yi on 22/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import JGProgressHUD

extension BaseVC {
    // MARK: public
    func showLoading(_ show: Bool) {
        show ? beginLoad() : endLoad()
    }
    
    func onError(errorMessage: String) {
        showAlertView(message: errorMessage)
    }
}

class BaseVC: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoadingView()
    }
    // MARK: private
    private func initLoadingView() {
        hud.textLabel.text = "Loading"
    }
    private func beginLoad() {
        hud.show(in: self.view, animated: true)
    }
    private func endLoad() {
        hud.dismiss(animated: true)
    }
    
    private func showAlertView(message: String) {
        let alert = UIAlertController(
            title: "Sorry",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
