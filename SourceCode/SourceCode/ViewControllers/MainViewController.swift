//
//  MainViewController.swift
//  SourceCode
//
//  Created by Ashish on 01/12/21.
//

import UIKit
import MaterialComponents

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func setUpTexxtField(textField : MDCOutlinedTextField , errorText: String, placeHolder : String, isSecureText : Bool? = false, leftImageName : String? = "") {
        textField.label.text = placeHolder
        textField.placeholder = placeHolder
        textField.leadingAssistiveLabel.text = ""

        textField.setOutlineColor(AppColor, for: MDCTextControlState.editing)
        textField.setOutlineColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setTextColor(AppColor, for: MDCTextControlState.editing)
        textField.setTextColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setNormalLabelColor(AppColor, for: MDCTextControlState.editing)
        textField.setNormalLabelColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setFloatingLabelColor(AppColor, for: MDCTextControlState.editing)
        textField.setFloatingLabelColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.isSecureTextEntry = isSecureText!
        
        if leftImageName!.count > 0 {
            let leftImageView = UIImageView(frame: CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25)))
            leftImageView.image = UIImage(named: leftImageName!)
            textField.leftView = leftImageView
            textField.leftViewMode = .always
        }
        textField.sizeToFit()
    }
    

    
    func setUpErrorInTextField(textField : MDCOutlinedTextField , errorText: String) {
        textField.leadingAssistiveLabel.text = errorText
        
        textField.setLeadingAssistiveLabelColor(errorRedColor, for: MDCTextControlState.editing)
        textField.setLeadingAssistiveLabelColor(errorRedColor, for: MDCTextControlState.normal)
        
        textField.setOutlineColor(errorRedColor, for: MDCTextControlState.editing)
        textField.setOutlineColor(errorRedColor, for: MDCTextControlState.normal)
        
        textField.setNormalLabelColor(errorRedColor, for: MDCTextControlState.editing)
        textField.setNormalLabelColor(errorRedColor, for: MDCTextControlState.normal)
        
        textField.setFloatingLabelColor(errorRedColor, for: MDCTextControlState.editing)
        textField.setFloatingLabelColor(errorRedColor, for: MDCTextControlState.normal)

    }
    
    func removeErrorFromTextField(textField : MDCOutlinedTextField) {
        textField.leadingAssistiveLabel.text = ""
        
        textField.setOutlineColor(AppColor, for: MDCTextControlState.editing)
        textField.setOutlineColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setTextColor(AppColor, for: MDCTextControlState.editing)
        textField.setTextColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setNormalLabelColor(AppColor, for: MDCTextControlState.editing)
        textField.setNormalLabelColor(AppDarkGrayColor, for: MDCTextControlState.normal)
        
        textField.setFloatingLabelColor(AppColor, for: MDCTextControlState.editing)
        textField.setFloatingLabelColor(AppDarkGrayColor, for: MDCTextControlState.normal)
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        return (number.count > 9) ? true : false
    }
    
    
    // MARK :- API CALLS
    
    func getCountryCode() {
        
    }
}
