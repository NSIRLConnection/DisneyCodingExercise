//
//  CharacterDetailView.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

struct CharacterDetailView: View, Loadable {
    
    @StateObject var viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        case .ready(let comics):
            return InspectableView(innerView: ReadyBody(character: viewModel.character, comics: comics))
        }
    }
    
    func load() {
        viewModel.getComics()
    }
    
    struct ReadyBody: View {
        let character: Character
        let comics: [Comic]
        
        let rows = [
            GridItem(.fixed(300))
        ]
        
        var body: some View {
            VStack {
                CharacterDetailHeroView(character: character)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows) {
                        ForEach(comics) { comic in
                            NavigationLink {
                                // TODO: Outside of scope for exercise, comic detail view
                            } label: {
                                AsyncImage(
                                    url: comic.thumbnailImageURL,
                                    content: { phase in
                                        phase.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }).frame(minWidth: 300, minHeight: 300)
                                Text("\(comic.title)")
                            }.frame(minWidth: 400, minHeight: 420)
                        }
                    }
                }
            }
        }
    }
    
    struct CharacterDetailHeroView: View {
        
        let character: Character
        
        var body: some View {
            HStack {
                AsyncImage(
                   url: character.thumbnailImageURL,
                    content: { phase in
                        phase.image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 600, maxHeight: 600)
                    }).frame(minWidth: 600, minHeight: 600)
                VStack {
                    Text(character.name)
                    Text(character.description)
                }.frame(minWidth: 1100, minHeight: 600)
            }
        }
    }
    
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let provider = MockMarvelServiceProvider()
        provider.getComicsResult = .success([Comic.testComic])
        let viewModel = CharacterDetailViewModel(character: Character.testCharacter, marvelService: provider)
        return CharacterDetailView(viewModel: viewModel)
    }
}
