//
//  WebViewVC.swift
//  FitShare
//
//  Created by 222 on 6/22/20.
//

import Foundation
import UIKit

class MainLayoutWebView: UIView {
    let webView = UIWebView()

    func configureView() {
        backgroundColor = UIColor.contentBgColor
        addSubview(webView)
        webView.backgroundColor = UIColor.contentBgColor
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
    }

    func applyConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WebViewVC: UIViewController {
    var contentView: MainLayoutWebView = MainLayoutWebView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var url: String = ""

    func loadAgreementPdf() {
        let url = URL(string: self.url)
        
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { _, _, error in

                DispatchQueue.main.async {
                    if error == nil {
                        self.contentView.webView.loadRequest(request)
                        self.contentView.webView.scrollView.contentSize.width = 100
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.showError("Agreement Document failed to load, try again or visit our website")
                    }
                }
            }
            task.resume()
        }
    }

    private func zoomToFit() {
        let scrollView = contentView.webView.scrollView

        let zoom = contentView.webView.bounds.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = zoom
        scrollView.setZoomScale(zoom, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.webView.scalesPageToFit = true
    }
}
