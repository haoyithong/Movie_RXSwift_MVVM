//
//  WebviewViewController.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController, WKUIDelegate {
    
    var url: String!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
