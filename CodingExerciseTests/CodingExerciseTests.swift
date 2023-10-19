//
//  CodingExerciseTests.swift
//  CodingExerciseTests
//
//  Created by Michael Yau on 10/18/23.
//

import SwiftUI
import XCTest
@testable import CodingExercise

final class CodingExerciseTests: XCTestCase {
    
    var serviceProvider: MockMarvelServiceProvider!
    let testerman: CodingExercise.Character = Character(id: 123, name: "Testerman", description: "123 test", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", extension: "test"))
    let mockError = NSError(domain: "com.michaelyau.codingexercise.mockerror", code: 2001)
    

    override func setUpWithError() throws {
        serviceProvider = MockMarvelServiceProvider()
    }

    override func tearDownWithError() throws {
        serviceProvider = nil
    }

    func testGivenResponseData_CharacterListDecodesCorrectly() throws {
        let jsonDecoder = JSONDecoder()
        let response = try jsonDecoder.decode(CharacterListResponse.self, from: characterListResponse)
        XCTAssertEqual(response.code, 200)
        XCTAssertEqual(response.data.results.count, 20)
        let character = response.data.results.first!
        XCTAssertEqual(character.id, 1011334)
        XCTAssertEqual(character.name, "3-D Man")
        let url = URL(string:"http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
        XCTAssertEqual(character.thumbnailImageURL, url)
    }
    
    func testGivenResponseData_ComicListDecodesCorrectly() throws {
        let jsonDecoder = JSONDecoder()
        let response = try jsonDecoder.decode(ComicListResponse.self, from: comicListResponse)
        XCTAssertEqual(response.code, 200)
        XCTAssertEqual(response.data.results.count, 20)
        let comic = response.data.results.first!
        XCTAssertEqual(comic.id, 103120)
        XCTAssertEqual(comic.title, "Who Is...? M.O.D.O.K. Infinity Comic (2023) #1")
        let url = URL(string:"http://i.annihil.us/u/prod/marvel/i/mg/5/00/63bd9786689b9.jpg")
        XCTAssertEqual(comic.thumbnailImageURL, url)
    }
    
    func testGivenCharacterListView_WhenItIsLoading_ThenISeeEmptyOrLoadingView() {
        //Note: Due to the delay viewModel will be retained
        serviceProvider.delayInSeconds = 30
        let viewModel = CharacterListViewModel(marvelService: serviceProvider)
        let view = CharacterListView(viewModel: viewModel)
        XCTAssertTrue(view.body.innerView is LoadingView)
    }
    
    func testGivenCharacterListView_WhenIHaveCharacterData_ThenISeeCharacters() {
        serviceProvider.getCharactersResult = .success([testerman])
        let viewModel = XCTAssertNoCycle(CharacterListViewModel(marvelService: serviceProvider))
        viewModel.getCharacters()
        let view = CharacterListView(viewModel: viewModel)
        XCTAssertTrue(view.body.innerView is CharacterListView.ReadyBody)
    }
    
    
    func testGivenCharacterListView_WhenIReceiveAnError_ThenISeeErrorView() {
        serviceProvider.getCharactersResult = .failure(mockError)
        let viewModel = XCTAssertNoCycle(CharacterListViewModel(marvelService: serviceProvider))
        viewModel.getCharacters()
        let view = CharacterListView(viewModel: viewModel)
        XCTAssertTrue(view.body.innerView is ErrorView)
    }
    
    func testGivenCharacterDetailView_WhenItIsLoading_ThenISeeEmptyOrLoadingView() {
        //Note: Due to the delay viewModel will be retained
        serviceProvider.delayInSeconds = 30
        let viewModel = CharacterDetailViewModel(character: testerman, marvelService: serviceProvider)
        viewModel.getComics()
        let view = CharacterDetailView(viewModel: viewModel)
        XCTAssertTrue(view.body.innerView is LoadingView)
    }
    
    func testGivenCharacterDetailView_WhenIHaveComicsData_ThenISeeCharacters() {
        let viewModel = XCTAssertNoCycle(CharacterDetailViewModel(character: testerman, marvelService: serviceProvider))
        viewModel.getComics()
        let view = CharacterDetailView(viewModel: viewModel)
        let innerView = view.body.innerView
        print(innerView)
        XCTAssertTrue(innerView is CharacterDetailView.ReadyBody)
    }
    
    func testGivenCharacterDetailView_WhenIReceiveAnError_ThenISeeErrorView() {
        serviceProvider.getComicsResult = .failure(mockError)
        let viewModel = XCTAssertNoCycle(CharacterDetailViewModel(character: testerman, marvelService: serviceProvider))
        viewModel.getComics()
        let view = CharacterDetailView(viewModel: viewModel)
        let innerView = view.body.innerView
        print(innerView)
        XCTAssertTrue(innerView is ErrorView)
    }
    
    func testThatMarvelServiceURL_decoratesWithURLComponents() throws {
        let service = MarvelServiceProvider(publicKey: "test", privateKey: "test")
        let date = Date(timeIntervalSince1970: 1234)
        let url = try service.url(request: MockRequest(), date: date)
        XCTAssertEqual(url.absoluteString, "http://www.test.com?ts=\(date.timeIntervalSince1970)&apikey=test&hash=4729f19cc2878456d898a795d0e18f5b")
    }
    
    private var characterListResponse: Data {
        mockResponse(resource:"MockCharacterListResponse")
    }
    
    private var comicListResponse: Data {
        mockResponse(resource: "MockComicListResponse")
    }

    private func mockResponse(resource: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: resource, withExtension: "json")
        return try! Data(contentsOf: XCTUnwrap(url))
    }
    
}

/// XCTestCase helper function, adds a teardown block to the object inputted, will assert if the object is retained after teardown
extension XCTestCase {
    @discardableResult
    func XCTAssertNoCycle<T: AnyObject>(_ object: T, file: StaticString = #file, line: UInt = #line) -> T {
        var source: T! = object
        weak var copy = object
        XCTAssertNotNil(source, file: file, line: line)
        XCTAssertNotNil(copy, file: file, line: line)
        source = nil
        addTeardownBlock {
            XCTAssertNil(source, file: file, line: line)
            XCTAssertNil(copy, file: file, line: line)
        }
        return object
    }
}


struct MockRequest: Request {
    var urlComponents: URLComponents? {
        URLComponents(string: "http://www.test.com")
    }
}
