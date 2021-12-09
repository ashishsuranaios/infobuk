//
//  ForgotPasswordVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialComponents

class ForgotPasswordVC: MainViewController {
    @IBOutlet weak var successViewBg: UIView!
    @IBOutlet weak var shadowBgSuccess: UIView!
    @IBOutlet weak var lblResetEmailDetail: UILabel!

    
    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var stack: UIStackView!

    @IBOutlet weak var txtEmail: MDCOutlinedTextField!

    var isShadowApplied = false



    let eyePasswordBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        successViewBg.isHidden = true
        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
        btnLogin.setCornerRadius(radius: appButtonCornerRadius)
        self.shadowBg.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    func setUI() {
        self.view.layoutIfNeeded()
        if (!isShadowApplied){
            isShadowApplied = true
            self.shadowBg.isHidden = false
            shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowBgSuccess.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
        }
        
        self.txtEmail.delegate = self
    }
    
   
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        self.view.endEditing(true)
        if isValidateForm() {
            self.startLoading()
            let param : [String : String] = ["email" : "\(txtEmail.text!)"]
            APICallManager.instance.requestForResetPassword(param: param) { [self] (res) in
                if res.success ?? false {
                    
                    var myMutableString = NSMutableAttributedString()
                    let myString = "Please check your email \(self.txtEmail.text!) and click on the included link to proceed."
                    myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "OpenSans-Regular", size: 15.0)!, NSAttributedString.Key.foregroundColor : AppGrayColor])
                    if let range = myString.range(of: self.txtEmail.text!) {
                        let nsRange = NSRange(range, in: myString)
                        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor, range: nsRange)
                    }
                    self.lblResetEmailDetail.attributedText = myMutableString
                    
                    self.successViewBg.isHidden = false


                } else {
                    if res.error?.keys.count ?? 0 > 0 {
                        self.setUpErrorInTextField(textField: self.txtEmail, errorText: res.error?.values.first ?? "Something went wrong")
                    }
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.removeErrorFromTextField(textField: txtEmail)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
