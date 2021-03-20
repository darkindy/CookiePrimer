//
//  ViewController.swift
//  Demo Swift Hello World
//
//  Created by Joel on 9/27/17.
//  Copyright © 2017 JoelParkerHenderson.com. All rights reserved.
//
import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        Swift.print("Loading view")
        webView = WKWebView()
        webView?.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
             Swift.print("Loaded view")
        super.viewDidLoad()
        //let url = URL(string: "l")!
        //webView.load(URLRequest(url: url))
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
