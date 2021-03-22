import Foundation
//
//  CorsProxy.swift
//  CookiePrimer
//
//  Created by Andrei Pietrusel on 3/22/21.
//  Copyright © 2021 Andrei Pietrusel (Darkindy). All rights reserved.
//
//  Origin https://gist.github.com/zqqf16/fc1b2f37eead98ec44b5bc682b07796b https://gist.github.com/sciolist/2e741ff651ffe58b28f4 */
class CorsProxy {
    var webServer: GCDWebServer
    
    init(webserver: GCDWebServer, urlPrefix: String) {
        self.webServer = webserver
        
        let prefix =
            (urlPrefix.hasPrefix("/") ? "" : "/")
                + urlPrefix
                + (urlPrefix.hasSuffix("/") ? "" : "/")
        
        let pattern = "^" + NSRegularExpression.escapedPattern(for: prefix) + ".*"
        
        webserver.addHandler(forMethod: "POST", pathRegex: pattern, request: GCDWebServerDataRequest.self, processBlock:{ req in
            return self.sendProxyResult(prefix, req: req)
        })
        
        webserver.addHandler(forMethod: "PUT", pathRegex: pattern, request: GCDWebServerDataRequest.self, processBlock:{ req in
            return self.sendProxyResult(prefix, req: req)
        })
        
        webserver.addHandler(forMethod: "PATCH", pathRegex: pattern, request: GCDWebServerDataRequest.self, processBlock:{ req in
            return self.sendProxyResult(prefix, req: req)
        })
        
        webserver.addHandler(forMethod: "DELETE", pathRegex: pattern, request: GCDWebServerDataRequest.self, processBlock:{ req in
            return self.sendProxyResult(prefix, req: req)
        })
        
        webserver.addHandler(forMethod: "GET", pathRegex: pattern, request: GCDWebServerRequest.self, processBlock:{ req in
            return self.sendProxyResult(prefix, req: req)
        })
        
        webserver.addHandler(forMethod: "OPTIONS", pathRegex: pattern, request: GCDWebServerRequest.self, processBlock:{ req in
            return self.sendCorsHeaders(prefix, req: req)
        })
    }
    
    func sendProxyResult(_ prefix: String, req: GCDWebServerRequest) -> GCDWebServerResponse? {
        let query = req.url.query == nil ? "" : "?" + req.url.query!
        let url = URL(string: req.path.substring(from: prefix.endIndex) + query)
        if (url == nil) { return sendError(error: "Invalid URL") }
        
        var urlResp: URLResponse?
        var urlReq = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 40)
        urlReq.httpMethod = req.method
        urlReq.allHTTPHeaderFields = req.headers as [String : String]
        urlReq.allHTTPHeaderFields?["Host"] = url!.host
        
        if (req.hasBody()) {
            urlReq.httpBody = (req as! GCDWebServerDataRequest).data
        }
        
        do {
            let output = try NSURLConnection.sendSynchronousRequest(urlReq, returning: &urlResp)
            
            if (urlResp == nil) {
                
                return sendError(error: String(data: output, encoding: String.Encoding.utf8));
            }
            
            let httpResponse = urlResp as! HTTPURLResponse
            let resp = GCDWebServerDataResponse(data: output, contentType: "application/x-unknown")
            resp.statusCode = httpResponse.statusCode
            for key in httpResponse.allHeaderFields {
                if (toString(v: key.0 as AnyObject) == "Content-Encoding") { continue; }
                resp.setValue(toString(v: key.1 as AnyObject), forAdditionalHeader: toString(v: key.0 as AnyObject))
            }
            resp.setValue(String(output.count), forAdditionalHeader: "Content-Length")
            return resp
        } catch {
            print("Proxy error: ", error.localizedDescription)
            return nil
        }
    }
    
    func sendCorsHeaders(_ prefix: String, req: GCDWebServerRequest) -> GCDWebServerResponse! {
        let resp = GCDWebServerResponse()
        resp.setValue(toString(v: req.headers["Origin"] as AnyObject), forAdditionalHeader: "Access-Control-Allow-Origin")
        resp.setValue("PUT,POST,GET,PATCH,DELETE", forAdditionalHeader: "Access-Control-Allow-Methods")
        resp.setValue("true", forAdditionalHeader: "Access-Control-Allow-Credentials")
        return resp
    }
    
    func sendError(error: String?) -> GCDWebServerResponse! {
        let msg = error == nil ? "An error occured" : error!
        let errorData = msg.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let resp = GCDWebServerDataResponse(data: errorData!, contentType: "text/plain")
        resp.statusCode = 500
        return resp
    }
    
    func toString(v: AnyObject?) -> String! {
        if (v == nil) { return ""; }
        return "\(v!)"
    }
}
