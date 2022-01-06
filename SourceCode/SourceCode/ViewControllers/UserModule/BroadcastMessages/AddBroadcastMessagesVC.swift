//
//  AddBroadcastMessagesVC.swift
//  SourceCode
//
//  Created by Apple on 02/01/22.
//

import UIKit
import MaterialComponents
import MaterialTextField
import GrowingTextView

class AddBroadcastMessagesVC: MainViewController {

    
    @IBOutlet weak var txtFieldSubject: MDCOutlinedTextField!
    @IBOutlet weak var txtViewMessage: GrowingTextView!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTextSubjCount: UILabel!
    @IBOutlet weak var lblTextMessageCount: UILabel!

    @IBOutlet weak var lblTitle: UILabel!

    var type = 0 // 0 - add, 1 - Edit

    var strTitleName = ""
    var recordEdit : BroadcastMessages?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.backgroundColor = .lightGray
        self.btnSave.alpha = 0.5
        self.btnSave.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtFieldSubject.becomeFirstResponder()
    }
    
    func setUI (){
        self.txtViewMessage.delegate = self
        self.txtFieldSubject.delegate = self
        
        self.setUpTexxtField(textField: txtFieldSubject, errorText: "Please enter a valid name", placeHolder: "Friendly Permission Name")
        self.txtViewMessage.layer.borderWidth = 1.0
        self.txtViewMessage.layer.borderColor = UIColor.lightGray.cgColor
        self.txtViewMessage.layer.cornerRadius = 8.0
        self.txtViewMessage.layer.masksToBounds = true

//        txtField.viewBorder(borderColor: AppColor, borderWidth: 1.5)
//        txtField.setCornerRadius(radius: 8.0)
        
        btnSave.setCornerRadius(radius: 8.0)
        btnCancel.setCornerRadius(radius: 8.0)

        lblTitle.text = strTitleName
        if (type == 0 ){
            btnSave.setTitle("   Save   ", for: .normal)
        } else {
            btnSave.setTitle("   Update   ", for: .normal)
        }
        
        if type == 1 {
            txtFieldSubject.text = recordEdit?.subject ?? ""
            txtViewMessage.text = recordEdit?.message ?? ""
        }
   
        self.updateSaveButton()

        
    }
    
    func updateSaveButton() {
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (self.txtFieldSubject.text?.count ?? 0 > 0) && (self.txtViewMessage.text?.count ?? 0 > 0) {
                self.btnSave.backgroundColor = AppColor
                self.btnSave.alpha = 1.0
                self.btnSave.isUserInteractionEnabled = true
            } else {
                self.btnSave.backgroundColor = .lightGray
                self.btnSave.alpha = 0.5
                self.btnSave.isUserInteractionEnabled = false
            }
            self.lblTextSubjCount.text = "\(self.txtFieldSubject.text?.count ?? 0)/50"
            self.lblTextMessageCount.text = "\(self.txtViewMessage.text?.count ?? 0)/1000"

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
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "update", "broadcastMessageId" : recordEdit?.id ?? "", "subject" : txtFieldSubject.text!, "message" : txtViewMessage.text!]
            
            APICallManager.instance.requestForBroadcastMessagesList(param: param) { (res) in
                if res.success ?? false {
                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()
                self.showAlert(msg: err)

            }
        } else if type == 0 { // for Add tag group
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "add", "subject" : txtFieldSubject.text!, "message" : txtViewMessage.text!]
            APICallManager.instance.requestForBroadcastMessagesList(param: param) { (res) in
                if res.success ?? false {
                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()
                self.showAlert(msg: err)

            }
        }
        
        
       
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension AddBroadcastMessagesVC : UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldSubject {
            if ((textField.text?.count ?? 0) == 50) && (string != "") {
                return false
            }
        }
        
        self.updateSaveButton()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtViewMessage {
           if ((textView.text?.count ?? 0) == 1000) && (text != "") {
               return false
           }
       }
       
       self.updateSaveButton()
       
       return true
    }
    
}
