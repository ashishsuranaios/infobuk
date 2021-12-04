//
//  PhoneCode.swift
//  SourceCode
//
//  Created by Apple on 04/12/21.
//

import Foundation

struct PhoneCode : Codable {
    let id : String?
    let name : String?
    let phoneCode : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case phoneCode = "phoneCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phoneCode = try values.decodeIfPresent(String.self, forKey: .phoneCode)
    }

}
