//
//  LoginVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialTextField
import MaterialComponents
import JWTDecode

class LoginVC: MainViewController {

    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!

    let eyePasswordBtn = UIButton(type: .custom)
    
    var isShadowApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtEmail.text = "ashish333k@gmail.com"//"paras@grr.la"//"ashishk_786@yahoo.com"
        self.txtPassword.text = "ashish@123"//"12345678"//"ashish@123"
        
        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
        self.setUpTexxtField(textField: txtPassword, errorText: "Please enter a valid password", placeHolder: "Password",isSecureText: true, leftImageName: "password_icon")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    func setUI() {
        self.view.layoutIfNeeded()
        if (!isShadowApplied){
            isShadowApplied = true
            shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
        }
        
        btnLogin.setCornerRadius(radius: appButtonCornerRadius)
        
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
 
        
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
        self.view.endEditing(true)
        if isValidateForm() {
            self.startLoading()
            let param : [String : String] = ["email" : "\(txtEmail.text!)", "password" : "\(txtPassword.text!)"]
            APICallManager.instance.requestForLogin(param: param) { [self] (res) in
                if res.success ?? false {
                    let jwt = try? decode(jwt: res.token ?? "")

                    UserDefaults.standard.set(jwt?.body, forKey: loginResponseLocal)
                    UserDefaults.standard.set(res.token, forKey: loginTokenLocal)
                    var allKeys = [String]()

                    if let orgDict = (jwt?.body["orgs"] as? [String : Any]) {
                        allKeys = Array(orgDict.keys)
                    }
                    UserDefaults.standard.set(allKeys, forKey: UD_OrgDictKeysArrayLocal)

                    
                    
                    
//                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "OrganisationListVC") as! OrganisationListVC
//                    self.navigationController?.pushViewController(controller, animated: true)
                    
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "OrganisationListVC")

                    let mySceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    let navigationController = UINavigationController(rootViewController: controller!)
                    navigationController.navigationBar.isHidden = true
                    mySceneDelegate.window?.rootViewController = navigationController
                    mySceneDelegate.window?.makeKeyAndVisible()
                } else {
                    if res.error?.keys.count ?? 0 > 0 {
                        if res.error?.keys.first == "password" {
                            self.setUpErrorInTextField(textField: self.txtPassword, errorText: res.error?.values.first ?? "Something went wrong")
                        } else if res.error?.keys.first == "email" {
                            self.setUpErrorInTextField(textField: self.txtEmail, errorText: res.error?.values.first ?? "Something went wrong")
                        }
                    }
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
           
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.removeErrorFromTextField(textField: txtEmail)
        self.removeErrorFromTextField(textField: txtPassword)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
