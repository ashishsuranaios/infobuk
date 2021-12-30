//
//  TagsModel.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import Foundation


struct TagsModel : Codable {
    var categoriesAndValues : [CategoriesAndValues]?
    let success : Bool?
    let token : String?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case categoriesAndValues = "categoriesAndValues"
        case success = "success"
        case token = "token"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoriesAndValues = try values.decodeIfPresent([CategoriesAndValues].self, forKey: .categoriesAndValues)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent(String.self, forKey: .error)

    }

}


struct CategoriesAndValues : Codable {
    let id : String?
    let name : String?
    let values_ : [Values]?
    let valuesSorted : [ValuesSorted]?
    var isSelected = false

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case values_ = "values"
        case valuesSorted = "valuesSorted"
        case isSelected = "isSelected"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        values_ = try values.decodeIfPresent([Values].self, forKey: .values_)
        valuesSorted = try values.decodeIfPresent([ValuesSorted].self, forKey: .valuesSorted)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false

    }

}

struct Values : Codable {
    let id : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}


struct ValuesSorted : Codable {
    let id : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}
