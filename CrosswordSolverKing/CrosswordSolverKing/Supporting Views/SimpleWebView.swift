//
//  WebViewRepresentable.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 07/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import WebKit

struct SimpleWebView : View {
    let urlRequest : URLRequest?
    @State private var isLoading = true
    var body: some View {
        ZStack(){
            if urlRequest != nil {
                WebViewRepresentable(urlRequest: urlRequest!,isLoading: $isLoading)
                VStack {
                    ActivityIndicatorRepresentable(isLoading: $isLoading)
                    if isLoading {
                        Text("Loading..")
                    } else {
                        Text("").hidden()
                    }
                }
            } else {
                Text("Unable to load")
            }
        }
    }
}

struct ActivityIndicatorRepresentable : UIViewRepresentable {
    @Binding var isLoading : Bool
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorRepresentable>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorRepresentable>) {
        isLoading ? uiView.startAnimating() : uiView.stopAnimating()
    }

}

struct WebViewRepresentable: UIViewRepresentable {
    let urlRequest : URLRequest
    @Binding var isLoading : Bool

    func makeUIView(context: UIViewRepresentableContext<WebViewRepresentable>) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(urlRequest)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebViewRepresentable>) {
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: WebNavCoordinator) {
        uiView.stopLoading()
    }
    
    func makeCoordinator() ->WebNavCoordinator {
        return WebNavCoordinator(self, isLoading: $isLoading)
    }
}

class WebNavCoordinator: NSObject, WKNavigationDelegate {
    let control : WebViewRepresentable
    var isLoading : Binding<Bool>

    init(_ control : WebViewRepresentable, isLoading : Binding<Bool>){
        self.control = control
        self.isLoading = isLoading
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        isLoading.wrappedValue = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading.wrappedValue = false
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isLoading.wrappedValue = false
    }

}
