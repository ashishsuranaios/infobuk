//
//  RegisterVC.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView

class RegisterVC: MainViewController {
    
    @IBOutlet weak var successViewBg: UIView!
    @IBOutlet weak var shadowBgSuccess: UIView!
    @IBOutlet weak var lblResetEmailDetail: UILabel!

    
    @IBOutlet weak var shadowBg: UIView!

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtName: MDCOutlinedTextField!
    @IBOutlet weak var txtCode: MDCOutlinedTextField!
    @IBOutlet weak var txtPhone: MDCOutlinedTextField!
    @IBOutlet weak var txtInstitureName: MDCOutlinedTextField!
    @IBOutlet weak var txtWebsite: MDCOutlinedTextField!
    @IBOutlet weak var dropDown : DropDown!

    @IBOutlet weak var imgAgreeTerms: UIImageView!

    let downArrowBtn = UIButton(type: .custom)
    var isAgreeTerms = false
    var phoneCodeArray = [PhoneCode]()
    var selectedPhoneCode : PhoneCode?
    var displayPhoneCodeArray = [PhoneCode]()

    var pickerView = UIPickerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        successViewBg.isHidden = true
        imgAgreeTerms.image = UIImage(named: "checkbox_unselected")

        // Do any additional setup after loading the view.        
//        self.txtEmail.text = "abcd123@mailinator.com"
//        self.txtName.text = "Abcd"
//        self.txtPhone.text = "545146548"
//        self.txtWebsite.text = "www.abcd.com"
//        self.txtInstitureName.text = "ABCD"
        
        self.setUpTexxtField(textField: txtEmail, errorText: "Please enter a valid email", placeHolder: "Email Address", leftImageName: "email_icon")
        self.setUpTexxtField(textField: txtName, errorText: "Please enter a valid Name", placeHolder: "Your Name", leftImageName: "name_icon")
        self.setUpTexxtField(textField: txtCode, errorText: "Please enter a valid Code", placeHolder: "Code", leftImageName: "code_icon")
        self.setUpTexxtField(textField: txtPhone, errorText: "Please enter a valid Phone Number", placeHolder: "Phone", leftImageName: "phone_icon")
        self.setUpTexxtField(textField: txtInstitureName, errorText: "Please enter a valid Institute Name", placeHolder: "Institute Name", leftImageName: "institute_icon")
        self.setUpTexxtField(textField: txtWebsite, errorText: "Please enter a valid Website", placeHolder: "Website (optional)", leftImageName: "website_icon")
        txtCode.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .allEditingEvents)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        pickerView.dataSource = self
//        pickerView.delegate = self
//
//        txtCode.delegate = self
//        txtCode.inputView = pickerView
        
        APICallManager.instance.getCountryListWithCodes { (arr) in
            self.phoneCodeArray = arr
            self.displayPhoneCodeArray = arr
        } onFailure: { (error) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    func setUI() {
        shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
        shadowBgSuccess.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)

        btnRegister.setCornerRadius(radius: appButtonCornerRadius)
        
        self.txtEmail.delegate = self
        self.txtName.delegate = self
        self.txtCode.delegate = self
        self.txtPhone.delegate = self
        self.txtInstitureName.delegate = self
        self.txtWebsite.delegate = self



        
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
        self.view.endEditing(true)

        if isValidateForm() {
            self.startLoading()
            let param : [String : String] = ["email" : "\(txtEmail.text!)", "name" : "\(txtName.text!)", "orgName" : "\(txtInstitureName.text!)", "Website" : "\(txtWebsite.text!)", "phoneCountryId" : "\(selectedPhoneCode!.id ?? "")", "phone" : "\(txtPhone.text!)"]
            APICallManager.instance.requestForSignUp(param: param) { (res) in
                if res.success ?? false {
                    var myMutableString = NSMutableAttributedString()
                    let myString = "Please check your email \(self.txtEmail.text!) and click on the included link to proceed."
                    myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "opensans_regular", size: 18.0)!, NSAttributedString.Key.foregroundColor : AppGrayColor])
                    if let range = myString.range(of: self.txtEmail.text!) {
                        let nsRange = NSRange(range, in: myString)
                        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor, range: nsRange)
                    }
                    self.lblResetEmailDetail.attributedText = myMutableString
                    self.successViewBg.isHidden = false
                } else {
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }

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
        
        if (self.selectedPhoneCode == nil) {
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
        
        if (!isAgreeTerms) {
            self.showAlert(msg : "Please accept terms and conditions.")
            return false
        }
        
        return true
    }

}


extension RegisterVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.removeErrorFromTextField(textField: txtEmail)
        self.removeErrorFromTextField(textField: txtCode)
        self.removeErrorFromTextField(textField: txtName)
        self.removeErrorFromTextField(textField: txtPhone)
        self.removeErrorFromTextField(textField: txtInstitureName)
        self.removeErrorFromTextField(textField: txtWebsite)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       // handle begin editing event
//        if textField == txtCode {
//            if self.phoneCodeArray.count > 0 {
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeSelectPopupVC") as! CountryCodeSelectPopupVC
//                controller.phoneCodeArray = self.phoneCodeArray
//                controller.parentVC = self
//                controller.displayPhoneCodeArray = self.phoneCodeArray
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//            return false
//        }
        if textField == txtCode {
            dropDown.showList()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCode {
            dropDown.hideList()
            if selectedPhoneCode != nil {
                self.txtCode.text = "\(selectedPhoneCode?.phoneCode ?? "") \(selectedPhoneCode?.name ?? "")"
            } else {
                txtCode.text = ""
            }
        }
    }
    
    @objc func textFieldValueChanged(textField : UITextField) {
        if (textField == txtCode){
//            txtCode.resignFirstResponder()
            
//            dropDown.becomeFirstResponder()
            if ((txtCode.text!.count <= 0)){
                displayPhoneCodeArray = phoneCodeArray
            } else {
                let filterServices = phoneCodeArray.filter({($0.name! + $0.phoneCode!).lowercased().range(of: self.txtCode.text!.lowercased()) != nil})
                displayPhoneCodeArray = filterServices
            }
            // The list of array to display. Can be changed dynamically
            var titleArray = [String]()

            for rec in self.displayPhoneCodeArray {
                titleArray.append("\(rec.phoneCode ?? "") \(rec.name ?? "")")
            }
            dropDown.optionArray = titleArray
            dropDown.isSearchEnable = false
            dropDown.text = txtCode.text ?? ""

            self.dropDown.showList()
            //Its Id Values and its optional
            // Image Array its optional
            // The the Closure returns Selected Index and String
            dropDown.didSelect{(selectedText , index ,id) in
                let rec = self.displayPhoneCodeArray[index]
                self.txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
                self.selectedPhoneCode = rec
                self.txtCode.resignFirstResponder()
            }
        }
    }
}

extension RegisterVC : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        phoneCodeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rec = phoneCodeArray[row]
        return "\(rec.phoneCode ?? "") \(rec.name ?? "")"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rec = phoneCodeArray[row]
        txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
        selectedPhoneCode = rec
        txtCode.resignFirstResponder()
    }
    
}
