//
//  BroadcastMsgModel.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import Foundation

struct BroadcastMsgModel : Codable {
    let broadcastMessages : [BroadcastMessages]?
    let success : Bool?
    let token : String?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case broadcastMessages = "broadcastMessages"
        case success = "success"
        case token = "token"
        case error = "error"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        broadcastMessages = try values.decodeIfPresent([BroadcastMessages].self, forKey: .broadcastMessages)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct BroadcastMessages : Codable {
    let id : String?
    let subject : String?
    let message : String?
    let isUsed : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case subject = "subject"
        case message = "message"
        case isUsed = "isUsed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        isUsed = try values.decodeIfPresent(String.self, forKey: .isUsed)
    }

}
