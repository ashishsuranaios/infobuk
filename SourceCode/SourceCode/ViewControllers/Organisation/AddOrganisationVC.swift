//
//  AddOrganisationVC.swift
//  SourceCode
//
//  Created by Apple on 05/12/21.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
import JWTDecode

class AddOrganisationVC: MainViewController {

    
    @IBOutlet weak var shadowBg: UIView!

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtName: MDCOutlinedTextField!
    @IBOutlet weak var txtCode: MDCOutlinedTextField!
    @IBOutlet weak var txtPhone: MDCOutlinedTextField!
    @IBOutlet weak var txtInstitureName: MDCOutlinedTextField!
    @IBOutlet weak var txtWebsite: MDCOutlinedTextField!


    let downArrowBtn = UIButton(type: .custom)
    var phoneCodeArray = [PhoneCode]()
    var selectedPhoneCode : PhoneCode?

    var pickerView = UIPickerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        
//        self.txtName.text = "Abcd"
//        self.txtPhone.text = "545146548"
//        self.txtWebsite.text = "www.abcd.com"
//        self.txtInstitureName.text = "ABCD"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickerView.dataSource = self
        pickerView.delegate = self

        txtCode.delegate = self
        txtCode.inputView = pickerView
        
        APICallManager.instance.getCountryListWithCodes { (arr) in
            self.phoneCodeArray = arr
        } onFailure: { (error) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUI() {
        shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)

        btnRegister.setCornerRadius(radius: appButtonCornerRadius)
        
        self.txtName.delegate = self
        self.txtCode.delegate = self
        self.txtPhone.delegate = self
        self.txtInstitureName.delegate = self
        self.txtWebsite.delegate = self

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
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        self.view.endEditing(true)

        if isValidateForm() {
            self.startLoading()
            let param : [String : String] = [ "name" : "\(txtName.text!)", "orgName" : "\(txtInstitureName.text!)", "Website" : "\(txtWebsite.text!)", "phoneCountryId" : "\(selectedPhoneCode!.id ?? "")", "phone" : "\(txtPhone.text!)"]
            APICallManager.instance.requestForAddOrganization(param: param) { (res) in
                if res.success ?? false {
                    let jwt = try? decode(jwt: res.token ?? "")

                    UserDefaults.standard.set(jwt?.body, forKey: loginResponseLocal)
                    UserDefaults.standard.set(res.token, forKey: loginTokenLocal)
                    
                    self.showAlertWithBackAction(msg: "Organization registered successfully.")
                } else {
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }

        }
    }
    
    func isValidateForm() -> Bool {
        self.removeErrorFromTextField(textField: txtCode)
        self.removeErrorFromTextField(textField: txtName)
        self.removeErrorFromTextField(textField: txtPhone)
        self.removeErrorFromTextField(textField: txtInstitureName)
        self.removeErrorFromTextField(textField: txtWebsite)

        
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
 
        
        return true
    }

}


extension AddOrganisationVC : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
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
}

extension AddOrganisationVC : UIPickerViewDataSource, UIPickerViewDelegate {
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
