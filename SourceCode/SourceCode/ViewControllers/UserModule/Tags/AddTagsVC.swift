//
//  AddTagsVC.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import UIKit

class AddTagsVC: MainViewController {
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTextCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    var strTitleName = ""
    var type = 0 // 0 = Add tag, 1 = Edit tag, 2 = Add Tag child, 3 = Edit Tag Child.
    var recordEdit : ValuesSorted?
    var recordTagGroup : CategoriesAndValues?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.backgroundColor = .lightGray
        self.btnSave.alpha = 0.5
        self.btnSave.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtField.becomeFirstResponder()
    }
    
    func setUI (){
        txtField.viewBorder(borderColor: AppColor, borderWidth: 1.5)
        txtField.setCornerRadius(radius: 8.0)
        
        btnSave.setCornerRadius(radius: 8.0)
        btnCancel.setCornerRadius(radius: 8.0)

        lblTitle.text = strTitleName
        if (type == 0 || type == 2){
            btnSave.setTitle("   Save   ", for: .normal)
        } else {
            btnSave.setTitle("   Update   ", for: .normal)
        }
        
        if type == 1 {
            txtField.text = recordTagGroup?.name ?? ""
        } else if type == 3 {
            txtField.text = recordEdit?.value ?? ""
        }
        self.updateSaveButton()

        
    }
    
    func updateSaveButton() {
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (self.txtField.text?.count ?? 0 > 0) {
                self.btnSave.backgroundColor = AppColor
                self.btnSave.alpha = 1.0
                self.btnSave.isUserInteractionEnabled = true
            } else {
                self.btnSave.backgroundColor = .lightGray
                self.btnSave.alpha = 0.5
                self.btnSave.isUserInteractionEnabled = false
            }
            self.lblTextCount.text = "\(self.txtField.text?.count ?? 0)/50"
            
        }
    }
    
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        var param : [String : String] = [String: String]()
        self.startLoading()

        if type == 1 {
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "update", "categoryName" : txtField.text!, "categoryId" : recordTagGroup?.id ?? ""]
            
            APICallManager.instance.requestForAddTagGroup(param: param) { (res) in
                if res.success ?? false {

                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        } else if type == 3 {
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "update", "valueName" : txtField.text!, "categoryId" : recordTagGroup?.id ?? "", "valueId" : recordEdit?.id ?? ""]
            APICallManager.instance.requestForAddTagChild(param: param) { (res) in
                if res.success ?? false {

                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        } else if type == 0 { // for Add tag group
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "add", "categoryName" : txtField.text!]
            APICallManager.instance.requestForAddTagGroup(param: param) { (res) in
                if res.success ?? false {

                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        } else if type == 2 { // for add tag child
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "add", "valueName" : txtField.text!, "categoryId" : recordTagGroup?.id ?? ""]
            APICallManager.instance.requestForAddTagChild(param: param) { (res) in
                if res.success ?? false {

                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        }
        
        
       
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension AddTagsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count ?? 0) == 50) && (string != "") {
            return false
        }
        
        self.updateSaveButton()
        
        return true
    }
    
}
