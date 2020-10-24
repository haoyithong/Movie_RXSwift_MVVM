//
//  BaseVC.swift
//  movie
//
//  Created by Thong Hao Yi on 22/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseVC: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoadingView()
    }
    
    private func initLoadingView() {
        hud.textLabel.text = "Loading"
    }
    
    func showLoading(_ show: Bool) {
        show ? beginLoad() : endLoad()
    }
    
    private func beginLoad() {
        hud.show(in: self.view, animated: true)
    }
    
    private func endLoad() {
        hud.dismiss(animated: true)
    }
}
