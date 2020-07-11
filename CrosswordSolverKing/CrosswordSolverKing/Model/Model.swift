//
//  Model.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Combine
import Foundation
import SwiftUtils

enum AppStates
{
    case uninitialized,loading, ready, searching, finished, error
}

enum AppErrors : Error {
    case loadError
}

class Model : ObservableObject,WordListCallback {
    
    static let appId = "id1503152101"
    static let privacyURL = "https://pigdogbay.blogspot.co.uk/2018/05/privacy-policy.html"
    static let itunesAppURL = "https://itunes.apple.com/app/id1503152101"

    @Published var query = ""
    @Published var matches : [String] = []
    @Published var appState = AppStates.uninitialized

    let wordList = WordList()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()
    
    private let scheduler = DispatchQueue.global(qos: .background)
    private var disposables = Set<AnyCancellable>()
    //Cannot place the search futures in a set as they will never be removed, since only one search at a time, can just use a property to store its reference
    private var temporaryDisposable : AnyCancellable?
    private let passthrough = PassthroughSubject<String,Never>()
    
    let filters = Filters()

    init(){
        self.wordSearch = WordSearch(wordList: self.wordList)

        passthrough
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {self.matches.append($0)})
            .store(in: &disposables)

        $query
            .dropFirst(1)
            .handleEvents(receiveOutput: {_ in self.wordList.stopSearch()}) //cancel any existing searches if user still typing
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .filter{$0 == self.query} //ignore any intermediate searches
            .sink(receiveValue: {self.search(searchQuery: $0)})
            .store(in: &disposables)

        temporaryDisposable = loadPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    self.appState = .ready
                case .failure( _):
                    self.appState = .error
                }},  receiveValue: { self.wordList.wordlist = $0})
    }

    func loadPublisher() -> Future<[String], AppErrors> {
        return Future<[String],AppErrors> { promise  in
            self.scheduler.async {
                if let path = Bundle.main.path(forResource: "words", ofType: "txt"),
                   let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
                {
                    let words = content.components(separatedBy: "\n")
                    promise(.success(words))
                } else {
                    promise(.failure(.loadError))
                }
            }
        }
    }
    
    func search(searchQuery : String){
        appState = .searching
        var processedQuery = query;
        processedQuery = self.wordSearch.preProcessQuery(processedQuery)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        wordFormatter.newSearch(processedQuery, searchType)
        //let filterPipeline = filterFactory.createChainedCallback(lastCallback: self)
        //filter.updateFilterCount()
        matches.removeAll()
        temporaryDisposable = searchPublisher(query: processedQuery, searchType: searchType)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in },  receiveValue: { self.appState = $0})
    }
    
    private func searchPublisher(query : String, searchType : SearchType) -> Future<AppStates, Never> {
        return Future<AppStates, Never> { promise in
            self.scheduler.async {
                self.wordSearch.runQuery(query, type: searchType, callback: self)
                promise(.success(.finished))
            }
        }
    }

    //WordListCallback - TODO maybe create a custom publisher to stream the results
    func update(_ result: String) {
        passthrough.send(result)
    }

    func clear() {
        matches.removeAll()
    }
}
