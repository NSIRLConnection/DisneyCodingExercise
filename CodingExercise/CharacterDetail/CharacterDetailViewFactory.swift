//
//  CharacterDetailViewFactory.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation

enum CharacterDetailViewFactory {
    
    static func make(_ character: Character) -> CharacterDetailView {
        let viewModel = CharacterDetailViewModel(character: character)
        return CharacterDetailView(viewModel: viewModel)
    }
    
}
