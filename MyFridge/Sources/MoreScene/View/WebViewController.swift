//
//  WebViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/23.
//

import WebKit
import UIKit

class WebViewController: UIViewController {
    var webView: WKWebView
    let url: URL
    
    init(url: URL) {
        self.webView = WKWebView()
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(webView)
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(URLRequest(url: self!.url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
