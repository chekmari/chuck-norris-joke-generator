//
//  JokeAPI.swift
//  Chuck Norris Joke
//
//  Created by macbook on 02.08.2023.
//

import Foundation
import Alamofire

// MARK: - Empty
struct ChuckNorrisJoke: Codable {
    let iconURL: URL
    let id: String
    let url: URL?
    let value: String

    enum CodingKeys: String, CodingKey {
        case iconURL = "icon_url"
        case id
        case url
        case value
    }
}
