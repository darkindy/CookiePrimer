# CookiePrimer
Proof of concept iOS app demonstrating how to serve a local (embedded) website in WKWebView, while also being able to make cross-origin remote AJAX calls and handle cookies without worrying about Same-Site restrictions.

The solution uses [GCDWebServer](https://github.com/swisspol/GCDWebServer) and shikaraba's Swift 4 rendition of sciolist's [CORS proxy](https://gist.github.com/sciolist/2e741ff651ffe58b28f4).

### How to run the proof of concept
1. Import the project in Xcode (I used version 11.5 & Swift 5)<br/></br>
2. Under the <b>Web</b> folder in Project navigator you will find a very basic static website having an index.html homepage.<br/>
   You can replace it down the line with your static website which you want to embed in the app.<br/></br>
3. Under the Web folder, for convenience, there is also a <b>controller</b> package containing PHP files for a very basic API that the homepage will call using AJAX.<br/><br/>
   To serve this api on your local network, in terminal navigate to the <b>Web</b> folder from earlier (<b>not the controller</b> folder) and run the following command, replacing the IP with your Mac's:
   ```bash
   php -S 192.168.100.2:8083
   ```
4. Open the <b>index.html</b> from the <b>Web</b> folder in Xcode and edit the `$apiUrl` variable at the top of the scripts.<br/>
   As you see from the code, we are pointing any AJAX calls to the PHP API we have exposed on the local network in the last step.<br/><br/>
   As observed, in order to enable cross-origin AJAX calls and Same-Site cookies, we must prefix our target url with `http://localhost:8884/CORS/`. If our API is running at 192.168.100.2:8083 as configured above, then the value for the `$apiUrl` variable will be:
   ```javascript
   var $apiUrl = "http://localhost:8884/CORS/http://192.168.100.2:8083"
   ```
5. Deploy the application on your device using Xcode. The basic website served has two buttons: <b>Login</b> and <b>Get protected message</b>.<br/><br/>
   The <b>Login</b> button will initiate an AJAX call to the API. During the response, a cookie will be set. GET is used for simplicity's sake. The cookie expires in 12 seconds to facilitate testing.<br/><br/>
   The <b>Get protected message</b> button will return different messages based on the presence of the non-expired cookie set using the Login button.

### Conclusion
The above POC testing instructions demonstrate that our GCDWebServer bound to localhost:8884 on your iOS device is capable of proxying calls to a cross-origin API on a specific `/CORS/` subpath. All the other paths served by the lightweight webserver are considered resources of the embedded website.<br/><br/>
Modifying the above POC to enable similar behavior for your local website should be self-explanatory. Feel free to experiment and alter the code to suit your needs.
