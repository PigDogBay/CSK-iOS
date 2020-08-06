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
    case uninitialized,ready, searching, finished, error
}

enum AppErrors : Error {
    case loadError
}

class Model : WordListCallback {
    
    @Published var query = ""
    @Published var matches : [String] = []
    @Published var appState = AppStates.uninitialized

    let wordList = WordList()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()
    var resultsLimit = 5000
    let filters = Filters()

    private let scheduler = DispatchQueue.global(qos: .background)
    private var disposables = Set<AnyCancellable>()
    //Cannot place the search futures in a set as they will never be removed, since only one search at a time, can just use a property to store its reference
    private var temporaryDisposable : AnyCancellable?
    private let passthrough = PassthroughSubject<String,Never>()
    //Background queue only - stops the search when the results limit is hit
    private var matchesCount = 0

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
            .filter{$0 == self.query && (self.appState == .ready || self.appState == .finished)} //ignore any intermediate searches
            .sink(receiveValue: {self.search(searchQuery: $0)})
            .store(in: &disposables)

    }
    
    func loadWordList(name : String) {
        self.appState = .uninitialized
        temporaryDisposable = loadPublisher(wordListName: name)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    self.appState = .ready
                case .failure( _):
                    self.appState = .error
                }},  receiveValue: { self.wordList.wordlist = $0})

    }

    private func loadPublisher(wordListName : String) -> Future<[String], AppErrors> {
        return Future<[String],AppErrors> { promise  in
            self.scheduler.async {
                if let path = Bundle.main.path(forResource: wordListName, ofType: "txt"),
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
        if searchQuery == "" {
            appState = .ready
            return
        }
        appState = .searching
        var processedQuery = self.wordSearch.preProcessQuery(searchQuery)
        let searchType = self.wordSearch.getQueryType(processedQuery)
        processedQuery = self.wordSearch.postProcessQuery(processedQuery, type: searchType)
        wordFormatter.newSearch(processedQuery, searchType)
        let filterPipeline = filters.createChainedCallback(lastCallback: self)
        matches.removeAll()
        temporaryDisposable = searchPublisher(query: processedQuery, searchType: searchType, callback: filterPipeline)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in },  receiveValue: { self.appState = $0})
    }
    
    func applyFilters(){
        if filters.isSearchRequired{
            filters.isSearchRequired = false
            search(searchQuery: query)
        }
    }
    
    private func searchPublisher(query : String, searchType : SearchType, callback : WordListCallback) -> Future<AppStates, Never> {
        return Future<AppStates, Never> { promise in
            self.scheduler.async {
                self.matchesCount = 0
                self.wordSearch.runQuery(query, type: searchType, callback: callback)
                promise(.success(.finished))
            }
        }
    }
    
    /*
     This code is called from the background queue
     */
    func update(_ result: String) {
        passthrough.send(result)
        //terminate runQuery() if results limit is hit
        matchesCount = matchesCount + 1
        if matchesCount == resultsLimit {
            wordList.stopSearch()
        }
    }

    func clear() {
        matches.removeAll()
    }
    
    func reset(){
        if self.appState == .ready || self.appState == .finished {
            query = ""
            filters.reset()
        } else {
            stopSearch()
        }
    }
    
    func stopSearch(){
        wordList.stopSearch()
    }
}
