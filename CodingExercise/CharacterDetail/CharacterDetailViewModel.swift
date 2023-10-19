//
//  CharacterDetailViewModel.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation

final class CharacterDetailViewModel: ObservableObject {
    
    @Published private(set) var viewState: ViewState<[Comic], NSError> = .empty
    
    let character: Character
    let marvelService: MarvelServiceProviding
    
    init(character: Character, marvelService: MarvelServiceProviding = MarvelServiceProvider.sharedInstance) {
        self.character = character
        self.marvelService = marvelService
    }
    
    func getComics() {
        Task {
            do {
                let comics = try await marvelService.getComics(characterId: character.id)
                viewState = .ready(comics)
            } catch {
                viewState = .error(error as NSError)
            }
        }
    }
    
}

