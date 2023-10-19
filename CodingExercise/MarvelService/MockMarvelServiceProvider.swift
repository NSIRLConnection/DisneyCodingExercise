//
//  MockMarvelServiceProvider.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation

final class MockMarvelServiceProvider: MarvelServiceProviding {
    var delayInSeconds: Int = 0
    var getCharactersResult: Result<[Character], NSError> = .success([])
    
    func getCharacters() async throws -> [Character] {
        try await Task.sleep(for: .seconds(delayInSeconds))
        switch getCharactersResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    var getComicsResult: Result<[Comic], NSError> = .success([])
    func getComics(characterId: Int) async throws -> [Comic] {
        try await Task.sleep(for: .seconds(delayInSeconds))
        switch getComicsResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
