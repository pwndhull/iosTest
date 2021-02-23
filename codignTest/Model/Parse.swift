//
//  Parse.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import Foundation


public struct LoggedUserInfoData: Codable {

    var authToken           : String?
    private enum CodingKeys : String, CodingKey {
        case authToken

    }
}


struct InfoLoggedUser : Codable {
    let token           : String?
//    let user_detail     : user_details?
}
struct PhotosD : Codable {
    let photosDetails : [Photos]?
}

struct Photos : Codable {
    let albumId         : Int?
    let id             : Int?
    let title          : String?
    let url             : String?
    let thumbnailUrl    : String?
}

struct Posts :Codable {
    let userId         : Int?
    let id             : Int?
    let tititletle          : String?
    let body             : String?
}
