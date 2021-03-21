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
    var webServer: GCDWebServer?
    
    override func loadView() {
        Swift.print("Loading view")
        webView = WKWebView()
        //webView?.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
             Swift.print("Loaded view")
        super.viewDidLoad()
        initWebServer()
        //let url = URL(string: "l")!
        //webView.load(URLRequest(url: url))
        
//        let path = Bundle.main.path(forResource: "index", ofType: "html")
//        let url = URL(fileURLWithPath: path!)
//
//        print("URL \(url.absoluteString)")
//
//        webView.loadFileURL(url, allowingReadAccessTo: url)
//        let request = URLRequest(url: url)
//        webView.load(request)
//
//        webView.allowsBackForwardNavigationGestures = true
        loadDefaultIndexFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadDefaultIndexFile() {

        
        
        //print("HTML base folder Path: \(folderPath)")

        let url = webServer!.serverURL!
        print("Serving local pages from \(url)")
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
      func initWebServer() {

        
        webServer = GCDWebServer()
        
        

                guard let folderPath = Bundle.main.path(forResource: "Web", ofType: nil) else {
            print("eroare la path")
            return
        }
        
        let fileURL = URL(fileURLWithPath:folderPath)
        if let _ = try? fileURL.checkResourceIsReachable()  {
           print("file exists")
        } else {
            print("file does not exist")
        }
        
                self.webServer!.addGETHandler(forBasePath: "/",
                                                directoryPath: folderPath,
                                                indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        
        let options: [String: Any] = [
            GCDWebServerOption_BindToLocalhost: true,
            GCDWebServerOption_Port: 8084
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
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//
//
//      guard let response = navigationResponse.response as? HTTPURLResponse,
//        let url = navigationResponse.response.url else {
//        decisionHandler(.cancel)
//        return
//      }
//
//      if let headerFields = response.allHeaderFields as? [String: String] {
//        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
//        cookies.forEach { cookie in
//          webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
//        }
//      }
//
//      decisionHandler(.allow)
//    }
}
