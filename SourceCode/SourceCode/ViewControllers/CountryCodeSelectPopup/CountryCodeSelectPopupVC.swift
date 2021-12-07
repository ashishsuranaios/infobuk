//
//  CountryCodeSelectPopupVC.swift
//  SourceCode
//
//  Created by Ashish on 07/12/21.
//

import UIKit

class CountryCodeSelectPopupVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!


    var phoneCodeArray = [PhoneCode]()
    var displayPhoneCodeArray = [PhoneCode]()

    var selectedPhoneCode : PhoneCode?
    var parentVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtSearch.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CustomOnlyLabelCell", bundle: nil), forCellReuseIdentifier: "CustomOnlyLabelCell")
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    
    func setUI(){
        tblView.reloadData()
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension CountryCodeSelectPopupVC : UITextFieldDelegate {
    @objc func textFieldValueChanged(textField : UITextField) {
        if ((txtSearch.text!.count <= 0)){
            displayPhoneCodeArray = phoneCodeArray
        } else {
            let filterServices = phoneCodeArray.filter({($0.name! + $0.phoneCode!).lowercased().range(of: self.txtSearch.text!.lowercased()) != nil})
            displayPhoneCodeArray = filterServices
        }
        tblView.reloadData()
    }
}


extension CountryCodeSelectPopupVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayPhoneCodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomOnlyLabelCell", for: indexPath) as! CustomOnlyLabelCell
        let rec = displayPhoneCodeArray[indexPath.row]
        customCell.lblTitle.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
        customCell.selectionStyle = .none
        return customCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rec = displayPhoneCodeArray[indexPath.row]

        if parentVC is RegisterVC {
            (parentVC as! RegisterVC).selectedPhoneCode = rec
            (parentVC as! RegisterVC).txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
            self.navigationController?.popViewController(animated: true)
        } else if parentVC is AddOrganisationVC {
            (parentVC as! AddOrganisationVC).selectedPhoneCode = rec
            (parentVC as! AddOrganisationVC).txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
