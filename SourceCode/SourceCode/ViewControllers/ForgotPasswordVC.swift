//
//  ForgotPasswordVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialComponents

class ForgotPasswordVC: MainViewController {

    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!

    let eyePasswordBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    func setUI() {
        shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
        
        btnLogin.setCornerRadius(radius: appButtonCornerRadius)
        
        self.txtEmail.delegate = self
        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
    }
    
   
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        if isValidateForm() {
            
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValidateForm() -> Bool {
        self.removeErrorFromTextField(textField: txtEmail)

        if (self.txtEmail.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a email.")
            return false
        } else if (!self.txtEmail.text!.isEmail) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a valid email.")
            return false
        }
        
        return true
    }

}

extension ForgotPasswordVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
