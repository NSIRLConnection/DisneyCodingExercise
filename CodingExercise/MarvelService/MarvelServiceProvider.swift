//
//  MarvelServiceProvider.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation
import CryptoKit

private func md5Hash(_ source: String) -> String {
    return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
}

final class MarvelServiceProvider: MarvelServiceProviding {
    
    static let sharedInstance = MarvelServiceProvider()
    
    private let publicKey: String
    private let privateKey: String
    let isInitialized: Bool // flag for displaying "Please add API keys to MarvelServiceProvider.swift!"
    
    //FIXME: Normally I would pass in some sort of configuration for base url, public key, private key, I skipped it and put it directly in here since there's only one environment we're working with
    init(
        publicKey: String = "",
        privateKey: String = "") {
        self.publicKey = publicKey
        self.privateKey = privateKey
            if publicKey.isEmpty || privateKey.isEmpty {
                isInitialized = false
            } else {
                isInitialized = true
            }
    }
    
    func getCharacters() async throws -> [Character] {
        let data = try await data(request: GetCharactersRequest())
        let foo = try JSONDecoder().decode(CharacterListResponse.self, from: data)
        return foo.data.results
    }
    
    func getComics(characterId: Int) async throws -> [Comic] {
        let data = try await data(request: GetCharacterComicsRequest(characterId: characterId))
        let response = try JSONDecoder().decode(ComicListResponse.self, from: data)
        return response.data.results
    }
    
    func data(request: Request) async throws -> Data {
        let url = try url(request: request)
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return data
    }
    
    func url(request: Request, date: Date = Date()) throws -> URL {
        var components = request.urlComponents
        components?.queryItems = queryItems(date: date)
        guard let url = components?.url else {
            throw NSError.malformedUrlError
        }
        return url
    }
    
    private func queryItems(date: Date = Date()) -> [URLQueryItem] {
        let dateString = String("\(date.timeIntervalSince1970)")
        let concatenated = dateString + privateKey + publicKey
        let md5Hash = md5Hash(concatenated)
        return [URLQueryItem(name: "ts", value: dateString),
        URLQueryItem(name: "apikey", value: publicKey),
        URLQueryItem(name: "hash", value: md5Hash)]
    }
    
}

protocol Request {
    var urlComponents: URLComponents? { get }
}

struct GetCharactersRequest: Request {
    var urlComponents: URLComponents? {
        URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters")
    }
}

struct GetCharacterComicsRequest: Request {
    let characterId: Int
    
    var urlComponents: URLComponents? {
        URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters/\(characterId)/comics")
    }
}

extension NSError {
    static var malformedUrlError: NSError {
        NSError(domain: "com.michaelyau.codingexercise.urlMalformedError", code: -2001)
    }
}
