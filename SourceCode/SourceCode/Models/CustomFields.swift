//
//  CustomFIelds.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import Foundation

struct CustomFields : Codable {
    let fields : [Fields]?
    let success : Bool?
    let token : String?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case fields = "fields"
        case success = "success"
        case token = "token"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fields = try values.decodeIfPresent([Fields].self, forKey: .fields)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent(String.self, forKey: .error)

    }

}

struct Fields : Codable {
    let fieldId : String?
    let fieldName : String?
    let fieldType : String?
    let optionNames : [String]?
    let isUnique : String?
    let isSearchable : String?

    enum CodingKeys: String, CodingKey {

        case fieldId = "fieldId"
        case fieldName = "fieldName"
        case fieldType = "fieldType"
        case optionNames = "optionNames"
        case isUnique = "isUnique"
        case isSearchable = "isSearchable"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fieldId = try values.decodeIfPresent(String.self, forKey: .fieldId)
        fieldName = try values.decodeIfPresent(String.self, forKey: .fieldName)
        fieldType = try values.decodeIfPresent(String.self, forKey: .fieldType)
        optionNames = try values.decodeIfPresent([String].self, forKey: .optionNames)
        isUnique = try values.decodeIfPresent(String.self, forKey: .isUnique)
        isSearchable = try values.decodeIfPresent(String.self, forKey: .isSearchable)
    }

}
