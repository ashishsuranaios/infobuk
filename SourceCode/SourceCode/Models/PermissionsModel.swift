//
//  Permissions.swift
//  SourceCode
//
//  Created by Apple on 31/12/21.
//

import Foundation

struct PermissionsModel : Codable {
    let success : Bool?
    let token : String?
    let permissions : [Permission]?
    let error : String?


    enum CodingKeys: String, CodingKey {

        case success = "success"
        case token = "token"
        case permissions = "permissions"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        permissions = try values.decodeIfPresent([Permission].self, forKey: .permissions)
        error = try values.decodeIfPresent(String.self, forKey: .error)

    }

}

struct Permission : Codable {
    let id : String?
    let name : String?
    let canView : String?
    let canBroadcast : String?
    let canTakeAttendance : String?
    let categoryAndValueTags : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case canView = "canView"
        case canBroadcast = "canBroadcast"
        case canTakeAttendance = "canTakeAttendance"
        case categoryAndValueTags = "categoryAndValueTags"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        canView = try values.decodeIfPresent(String.self, forKey: .canView)
        canBroadcast = try values.decodeIfPresent(String.self, forKey: .canBroadcast)
        canTakeAttendance = try values.decodeIfPresent(String.self, forKey: .canTakeAttendance)
        categoryAndValueTags = try values.decodeIfPresent([String].self, forKey: .categoryAndValueTags)
    }

}
