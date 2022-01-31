//
//  APIManager.swift
//  SourceCode
//
//  Created by Ashish on 02/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

let API_BASE_URL = "https://dev.infobuk.com/api/"

class APICallManager {
    static let instance = APICallManager()
    
    enum RequestMethod {
        case get
        case post
    }
    
    enum Endpoint: String {
        case GetPhoneCodeJson = "actions/getPhoneCodeJson"
        case AddOrg = "addOrg"
        case Login = "actions/login"
        case ResetPassword = "actions/sendPasswordResetLink"
        case tagsRelated = "actions/handleCategories"
        case tagsChildRelated = "actions/handleValueByCategoryId"
        case PermissionsApi  = "actions/handlePermissions"
        case CustomFields = "actions/handleFields"
        case BroadcastMessages = "actions/manageBroadcastMessage"
        case OrgStatusChange = "actions/changeOrgStatus"

    }
    
    // MARK : GET COUNTRY LIST WITH CODES
    
    func getCountryListWithCodes(onSuccess successCallback : ((_ countryList : [PhoneCode]) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.GetPhoneCodeJson.rawValue

        // call API
        self.createRequest(
            url, method: .get, headers: nil, parameters: nil,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.arrayObject {
                    let responseModel : [PhoneCode] = self.stringArrayToData(stringArray: responseObject.arrayObject!) as! [PhoneCode]
//                    // Fire callback
                    successCallback?(responseModel)
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : SIGN UP API
    
    func requestForSignUp(param : [String : String], onSuccess successCallback : ((_ countryList : SignUpModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.AddOrg.rawValue
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(SignUpModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
                    } else {
                        failureCallback?("An error has occured.")
                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : SIGN UP API
    
    func requestForLogin(param : [String : String], onSuccess successCallback : ((_ countryList : LoginModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.Login.rawValue
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    successCallback?(responseModel!)
       
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : SIGN UP API
    
    func requestForResetPassword(param : [String : String], onSuccess successCallback : ((_ countryList : SignUpModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.ResetPassword.rawValue
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(SignUpModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    successCallback?(responseModel!)
       
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : SIGN UP API
    
    func requestForAddOrganization(param : [String : String], onSuccess successCallback : ((_ countryList : LoginModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.AddOrg.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
                    } else {
                        failureCallback?("An error has occured.")
                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : TagList View API
    
    func requestForTagListView(param : [String : String], onSuccess successCallback : ((_ countryList : TagsModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.tagsRelated.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(TagsModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK : Add Tag Group
    
    func requestForAddTagGroup(param : [String : String], onSuccess successCallback : ((_ countryList : TagsModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.tagsRelated.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(TagsModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                          }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func requestForAddTagChild(param : [String : String], onSuccess successCallback : ((_ countryList : TagsModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.tagsChildRelated.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(TagsModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func requestForPermissionList(param : [String : String], onSuccess successCallback : ((_ countryList : PermissionsModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.PermissionsApi.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    var responseModel = try? jsonDecoder.decode(PermissionsModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
//                        successCallback?(responseDict, responseModel)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)
                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func requestForCustomFieldsList(param : [String : String], onSuccess successCallback : ((_ countryList : CustomFields) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.CustomFields.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(CustomFields.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
//                        successCallback?(responseDict, responseModel)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func requestForBroadcastMessagesList(param : [String : String], onSuccess successCallback : ((_ countryList : BroadcastMsgModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.BroadcastMessages.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(BroadcastMsgModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false {
                        successCallback?(responseModel!)
//                        successCallback?(responseDict, responseModel)
                    } else {
                        var errorStr = responseModel?.error ?? "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func requestForOrganisationStatusChanged(param : [String : String], onSuccess successCallback : ((_ countryList : LoginModel) -> Void)?, onFailure failureCallback: ((_ errorMessage : String) -> Void)?) {
        // Build URL
        let url = API_BASE_URL + Endpoint.OrgStatusChange.rawValue
        let token = UserDefaults.standard.value(forKey: loginTokenLocal) as? String ?? ""

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "*/*",
            "Authorization" : "Bearer \(token)"
        ]
        // call API
        self.createRequest(
            url, method: .post, headers: headers, parameters: param,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                // Convert JSON String to Model
               
                if let responseDict = responseObject.dictionaryObject {
                    let t1 = (try? JSONSerialization.data(withJSONObject: responseDict, options: []))!
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try? jsonDecoder.decode(LoginModel.self, from: t1)
//                    let responseModel : SignUpModel = self.stringArrayToData(stringArray: responseDict) as! SignUpModel
//                    // Fire callback
                    if responseModel?.success ?? false && ((responseModel?.token ?? "").count > 0) {
                        successCallback?(responseModel!)
//                        successCallback?(responseDict, responseModel)
                    } else {
                        var errorStr = "An error has occured."
                        errorStr = errorStr.replacingOccurrences(of: "<br>", with: "\n")
                        errorStr = errorStr.replacingOccurrences(of: "</br>", with: "")
                        failureCallback?(errorStr)                    }
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    func stringArrayToData(stringArray: Any) -> Any? {
        let t1 = (try? JSONSerialization.data(withJSONObject: stringArray, options: []))!
        let jsonDecoder = JSONDecoder()
        let responseModel = try? jsonDecoder.decode([PhoneCode].self, from: t1)
        return responseModel
    }
    

    
    // MARK: Request Handler
    // Create request
    func createRequest(
        _ url: String,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        parameters: [String : Any]?,
        onSuccess successCallback: ((JSON) -> Void)?,
        onFailure failureCallback: ((String) -> Void)?) {
        
        AF.request(url, method: method, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                successCallback?(json)
            case .failure(let error):
                if let callback = failureCallback {
                    // Return
                    callback(error.localizedDescription)
                }
            }
        }
    }
}
