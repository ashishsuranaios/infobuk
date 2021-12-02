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

let API_BASE_URL = "http://api.fozoglu.com"

class APICallManager {
    static let instance = APICallManager()
    
    enum RequestMethod {
        case get
        case post
    }
    
    enum Endpoint: String {
        case People = "/people.json"
    }
    
    // MARK: Contact
    func callAPIGetPeople(
        onSuccess successCallback: ((_ people: [PeopleModel]) -> Void)?,
        onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        
        // Build URL
        let url = API_BASE_URL + Endpoint.People.rawValue
        
        // call API
        self.createRequest(
            url, method: .get, headers: nil, parameters: nil,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                if let responseDict = responseObject["data"].arrayObject {
                    let peopleDict = responseDict as! [[String:AnyObject]]
                    
                    // Create object
                    var data = [PeopleModel]()
                    for item in peopleDict {
                        let single = PeopleModel.build(item)
                        data.append(single)
                    }
                    
                    // Fire callback
                    successCallback?(data)
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK: Request Handler
    // Create request
    func createRequest(
        _ url: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: AnyObject?,
        onSuccess successCallback: ((JSON) -> Void)?,
        onFailure failureCallback: ((String) -> Void)?) {
        
        
        AF.request(url, method: method).validate().responseJSON { response in
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
