//
//  Character.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/18/23.
//

import Foundation

struct Character: Decodable, Hashable, Identifiable, ThumbnailImageProviding {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension Character {
    static var testCharacter: Character {
        Character(id: 123,
                  name: "3-D Man",
                  description: "An American test pilot, Charles Chandler was abducted by Skrulls looking to use Earth as a strategic position in their war with the Kree. Escaping from the Skrull ship, and causing it to explode in the process, Charlie was engulfed in radiation as his brother Hal looked on. The explosion imprinted an image of Charlie on Hal's eyeglasses, and, through intense concentration, Hal could project Charlie into existence as The 3-D Man. However, this causes Hal to slip into a coma while Charlie is active. Through the years, the brothers traded consciousness and control of The 3-D Man, all while trying to balance a family. Eventually, the brothers would merge with a new 3-D Man, Delroy Garrett, Jr., before losing the powers all together.",
                  thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", extension: "jpg")
        )
    }
}

struct Thumbnail: Decodable, Hashable {
    let path: String
    let `extension`: String
}

struct Comic: Decodable, Hashable, Identifiable, ThumbnailImageProviding {
    let id: Int
    let title: String
    let thumbnail: Thumbnail
}

extension Comic {
    static var testComic: Comic {
        Comic(id: 103120, title: "Who Is...? M.O.D.O.K. Infinity Comic (2023) #1", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9", extension: "jpg"))
    }
}

protocol ThumbnailImageProviding {
    var thumbnail: Thumbnail { get }
    var thumbnailImageURL: URL? { get }
}

struct CharacterListResponse: Decodable {
    let code: Int
    let data: CharacterListResponseData
}

struct CharacterListResponseData: Decodable {
    let results: [Character]
}

extension ThumbnailImageProviding {
    var thumbnailImageURL: URL? {
        URL(string: "\(thumbnail.path).\(thumbnail.extension)")
    }
}

struct ComicListResponse: Decodable {
    let code: Int
    let data: ComicListResponseData
}

struct ComicListResponseData: Decodable {
    let results: [Comic]
}
