//
//  SearchModel.swift
//  Rick&Morty
//
//  Created by Ravan on 23.10.24.
//

import Foundation

struct SearchModel: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let episode: [String]
    let created: String
    let url: String
    let type: String
    let origin: Origin
    let location: Location
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct Location: Decodable {
    let name: String
    let url: String
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct SearchResponse: Decodable {
    let info: Info
    let results: [SearchModel]
    
    enum CodingKeys: String, CodingKey {
        case info
        case results = "results"
    }
}

