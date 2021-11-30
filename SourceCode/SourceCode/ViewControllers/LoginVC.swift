//
//  LoginVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var shadowBg: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    func setUI() {
        shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
    }


}
