//
//  SignUpModel.swift
//  SourceCode
//
//  Created by Apple on 04/12/21.
//

import Foundation
struct SignUpModel : Codable {
    let done : String?
    let do_ : String?
    let goToUrl : String?
    let emailToVerify : String?
    let success : Bool?
    let token : String?
    let error : [String : String]?

    enum CodingKeys: String, CodingKey {

        case done = "done"
        case do_ = "do"
        case goToUrl = "goToUrl"
        case emailToVerify = "emailToVerify"
        case success = "success"
        case token = "token"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        done = try values.decodeIfPresent(String.self, forKey: .done)
        do_ = try values.decodeIfPresent(String.self, forKey: .do_)
        goToUrl = try values.decodeIfPresent(String.self, forKey: .goToUrl)
        emailToVerify = try values.decodeIfPresent(String.self, forKey: .emailToVerify)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent([String: String].self, forKey: .error)

    }

}
