//
//  WebViewRepresentebel.swift
//  Place-To-Place-b
//
//  Created by СОВА on 20.08.2021.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: String?
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = URL(string: self.url!) else {return WKWebView()}
        let recvest = URLRequest(url: url)
        webView.load(recvest)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let urlValue = self.url  {
                    if let requestUrl = URL(string: urlValue) {
                        uiView.load(URLRequest(url: requestUrl))
                    }
                }
    }

}
struct LoaderView: View {
    @State var isSpinCircle = false
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60, alignment: .center)
            VStack {
                Circle()
                    .trim(from: 0.3, to: 1)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width:50, height: 50)
                    .padding(.all, 8)
                    .rotationEffect(.degrees(isSpinCircle ? 0 : -360), anchor: .center)
                    .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false))
                    .onAppear {
                        self.isSpinCircle = true
                    }
            }
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
import Combine

class ViewModel: ObservableObject {
    var isLoaderVisible = PassthroughSubject<Bool, Never>()
    var webTitle = PassthroughSubject<String, Never>()
    
}
