//
//  WebViewController.swift
//  CookiePrimer
//
//  Created by Andrei Pietrusel on 3/21/21.
//  Copyright © 2021 Andrei Pietrusel (Darkindy). All rights reserved.
//
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var webServer: GCDWebServer?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        //webView?.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebServer()
        loadDefaultIndexFile()
    }
    
    private func loadDefaultIndexFile() {
        let rootUrl = webServer!.serverURL!
        print("Serving index page from \(rootUrl)")
        let request = URLRequest(url: rootUrl)
        self.webView.load(request)
    }
    
    func initWebServer() {
        webServer = GCDWebServer()
        
        let folderPath = Bundle.main.path(forResource: "Web", ofType: nil)
        self.webServer!.addGETHandler(forBasePath: "/",
                                      directoryPath: folderPath!,
                                      indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        
        let _ = CorsProxy(webserver: webServer!, urlPrefix: "/CORS/")
        
        let options: [String: Any] = [
            GCDWebServerOption_Port: 8884,
            GCDWebServerOption_BindToLocalhost: true
        ]
        try? webServer!.start(options: options)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if host == "localhost" {
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.cancel)
    }
    
}
