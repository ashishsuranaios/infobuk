//
//  RegisterVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialComponents

class RegisterVC: MainViewController {
    
    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtName: MDCOutlinedTextField!
    @IBOutlet weak var txtCode: MDCOutlinedTextField!
    @IBOutlet weak var txtPhone: MDCOutlinedTextField!
    @IBOutlet weak var txtInstitureName: MDCOutlinedTextField!
    @IBOutlet weak var txtWebsite: MDCOutlinedTextField!

    @IBOutlet weak var imgAgreeTerms: UIImageView!

    let downArrowBtn = UIButton(type: .custom)
    var isAgreeTerms = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imgAgreeTerms.image = UIImage(named: "checkbox_unselected")

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
        
        btnRegister.setCornerRadius(radius: appButtonCornerRadius)
        
        self.txtEmail.delegate = self
        self.txtName.delegate = self
        self.txtCode.delegate = self
        self.txtPhone.delegate = self
        self.txtInstitureName.delegate = self
        self.txtWebsite.delegate = self

        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
        self.setUpTexxtField(textField: txtName, errorText: "Please enter a valid Name", placeHolder: "Your Name", leftImageName: "name_icon")
        self.setUpTexxtField(textField: txtCode, errorText: "Please enter a valid Code", placeHolder: "Code", leftImageName: "code_icon")
        self.setUpTexxtField(textField: txtPhone, errorText: "Please enter a valid Phone Number", placeHolder: "Phone", leftImageName: "phone_icon")
        self.setUpTexxtField(textField: txtInstitureName, errorText: "Please enter a valid Institute Name", placeHolder: "Institute Name", leftImageName: "institute_icon")
        self.setUpTexxtField(textField: txtWebsite, errorText: "Please enter a valid Website", placeHolder: "Website (optional)", leftImageName: "website_icon")

        
        downArrowBtn.setImage(UIImage(named: "dropdown_arrow"), for: .normal)
        downArrowBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        downArrowBtn.frame = CGRect(x: CGFloat(txtCode.frame.size.width - 20), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        txtCode.rightView = downArrowBtn
        txtCode.rightViewMode = .always
    }

    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAgreeTermsAndConditionClicked(_ sender: Any) {
        isAgreeTerms = !isAgreeTerms
        if isAgreeTerms {
            imgAgreeTerms.image = UIImage(named: "checkbox_selected")
        } else {
            imgAgreeTerms.image = UIImage(named: "checkbox_unselected")
        }
    }
    
    @IBAction func btnTermsAndConditionClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        if isValidateForm() {
            
        }
    }
    
    func isValidateForm() -> Bool {
        self.removeErrorFromTextField(textField: txtEmail)
        self.removeErrorFromTextField(textField: txtCode)
        self.removeErrorFromTextField(textField: txtName)
        self.removeErrorFromTextField(textField: txtPhone)
        self.removeErrorFromTextField(textField: txtInstitureName)
        self.removeErrorFromTextField(textField: txtWebsite)

        if (self.txtEmail.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a email.")
            return false
        } else if (!self.txtEmail.text!.isEmail) {
            self.setUpErrorInTextField(textField: txtEmail, errorText: "Please enter a valid email.")
            return false
        }
        
        if (self.txtName.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtName, errorText: "Please enter name.")
            return false
        }
        
        if (self.txtCode.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtCode, errorText: "Please select code.")
            return false
        }
        
        if (self.txtPhone.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtPhone, errorText: "Please enter valid phone number.")
            return false
        }
        
        if (self.txtInstitureName.text!.isBlank) {
            self.setUpErrorInTextField(textField: txtInstitureName, errorText: "Please enter insitute name.")
            return false
        }
        
        if (!self.txtWebsite.text!.isBlank) {
//            self.setUpErrorInTextField(textField: txtWebsite, errorText: "Please enter valid website.")
//            return false
        }
        
        return true
    }

}


extension RegisterVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
