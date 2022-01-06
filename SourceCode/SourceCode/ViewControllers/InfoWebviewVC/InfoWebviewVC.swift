//
//  InfoWebviewVC.swift
//  SourceCode
//
//  Created by Apple on 06/01/22.
//

import UIKit
import WebKit

class InfoWebviewVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!

    var strTitle : String = "Info"
    var htmlData : String = "Info"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI()  {
        lblTitle.text = strTitle
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        webView.loadHTMLString(headerString + htmlData, baseURL: nil)
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    

}
