//
//  CharacterListViewModel.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

final class CharacterListViewModel: ObservableObject {
    
    @Published private(set) var viewState: ViewState<[Character], NSError> = .empty
    
    private let marvelService: MarvelServiceProviding
    
    init(marvelService: MarvelServiceProviding = MarvelServiceProvider.sharedInstance) {
        self.marvelService = marvelService
    }
    
    func getCharacters() {
        Task {
            do {
                viewState = .loading
                let characters = try await marvelService.getCharacters()
                viewState = .ready(characters)
            } catch {
                viewState = .error(error as NSError)
            }
        }
    }
    
}
