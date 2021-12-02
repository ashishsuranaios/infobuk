//
//  LoginVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialTextField
import MaterialComponents

class LoginVC: MainViewController {

    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!

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
        self.txtPassword.delegate = self
        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
        self.setUpTexxtField(textField: txtPassword, errorText: "Please enter a valid password", placeHolder: "Password",isSecureText: true, leftImageName: "password_icon")
        
        eyePasswordBtn.setImage(UIImage(named: "eye_visible"), for: .normal)
        eyePasswordBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        eyePasswordBtn.frame = CGRect(x: CGFloat(txtPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        eyePasswordBtn.addTarget(self, action: #selector(self.eyeButtonClicked(_:)), for: .touchUpInside)
        txtPassword.rightView = eyePasswordBtn
        txtPassword.rightViewMode = .always
    }
    
    @IBAction func eyeButtonClicked(_ sender: UIButton) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        if !txtPassword.isSecureTextEntry {
            eyePasswordBtn.setImage(UIImage(named: "eye_notvisible"), for: .normal)
        } else {
            eyePasswordBtn.setImage(UIImage(named: "eye_visible"), for: .normal)
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        if isValidateForm() {
            
        }
    }
    
    @IBAction func btnSignupClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func isValidateForm() -> Bool {
        self.removeErrorFromTextField(textField: txtEmail)
        self.removeErrorFromTextField(textField: txtPassword)

        if (self.txtEmail.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a email.")
            return false
        } else if (!self.txtEmail.text!.isEmail) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a valid email.")
            return false
        }
        
        if (self.txtPassword.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtPassword, errorText: "Please enter password.")
            return false
        } else if (!self.txtPassword.text!.isValidPassword) {
            self.setUpErrorInTextField(textField: txtPassword, errorText: "Please enter atleast 8 characters as password.")
            return false
        }
        
        return true
    }

}

extension LoginVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
