//
//  LoginModel.swift
//  SourceCode
//
//  Created by Apple on 05/12/21.
//

import Foundation
struct LoginModel : Codable {
    let goToUrl : String?
    let success : Bool?
    let token : String?
    let error : [String : String]?

    enum CodingKeys: String, CodingKey {
        case goToUrl = "goToUrl"
        case success = "success"
        case token = "token"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        goToUrl = try values.decodeIfPresent(String.self, forKey: .goToUrl)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent([String: String].self, forKey: .error)

    }

}

