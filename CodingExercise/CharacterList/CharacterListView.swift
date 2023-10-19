//
//  CharacterListView.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

struct CharacterListView: View, Loadable {
    
    @StateObject private var viewModel: CharacterListViewModel
    
    init(viewModel: CharacterListViewModel = CharacterListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func load() {
        viewModel.getCharacters()
    }
    
    var body: InspectableView {
        switch viewModel.viewState {
        case .empty:
            defer { load() }
            return InspectableView(innerView: emptyOrLoadingBody)
        case .loading:
            return InspectableView(innerView: emptyOrLoadingBody)
        case .error(let error):
            return InspectableView(innerView: errorBody(error))
        case .ready(let characters):
            return InspectableView(innerView: ReadyBody(characters: characters))
        }
    }
    
    struct ReadyBody: View {
        
        let rows = [
            GridItem(.fixed(300))
        ]
        
        let characters: [Character]
        
        var body: some View {
            NavigationStack {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows) {
                        ForEach(characters) { character in
                            NavigationLink {
                                CharacterDetailViewFactory.make(character)
                            } label: {
                                VStack {
                                    AsyncImage(
                                        url: character.thumbnailImageURL,
                                        content: { phase in
                                            phase.image?
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: 300, maxHeight: 300)
                                                .clipShape(Circle())
                                        }).frame(minWidth: 300, minHeight: 300)
                                    Text("\(character.name)")
                                }.frame(minWidth: 400, minHeight: 420)
                            }
                        }
                    }.navigationTitle(Strings.popularCharacters)
                }
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        let provider = MockMarvelServiceProvider()
        provider.getCharactersResult = .success([Character.testCharacter])
        let viewModel = CharacterListViewModel(marvelService: provider)
        return CharacterListView(viewModel: viewModel)
    }
}
