//
//  MarvelServiceProviding.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation

protocol MarvelServiceProviding {
    
    func getCharacters() async throws -> [Character]
    func getComics(characterId: Int) async throws -> [Comic]
    
}
