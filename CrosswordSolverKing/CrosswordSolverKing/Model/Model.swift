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

class Model : ObservableObject {
    static let appId = "id1503152101"
    static let privacyURL = "https://pigdogbay.blogspot.co.uk/2018/05/privacy-policy.html"
    static let itunesAppURL = "https://itunes.apple.com/app/id1503152101"

    private let crosswordMatches = ["magee","mages","maggs","magic","magma","magog","magoo","magot","magus","mcgee","megan","miggs","might"]

    @Published var query = ""
    @Published var matches : [String] = []
    @Published var appState = AppStates.uninitialized

    let wordList = WordList()
    let wordSearch : WordSearch
    let wordFormatter = WordFormatter()

    
    private let scheduler = DispatchQueue.global(qos: .background)
    private var disposables = Set<AnyCancellable>()
    private let passthrough = PassthroughSubject<String,Never>()
    private var signalBreak = false
    
    let filters = Filters()

    init(){
        self.wordSearch = WordSearch(wordList: self.wordList)

        passthrough
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {self.matches.append($0)})
            .store(in: &disposables)

        $query
            .dropFirst(1)
            .handleEvents(receiveOutput: {_ in self.signalBreak = true}) //cancel any existing searches if user still typing
            .debounce(for: .seconds(0.5), scheduler: scheduler) //Search will run on background queue
            .filter{$0 == self.query} //ignore any intermediate searches
            .sink(receiveValue: {self.search(searchQuery: $0)})
            .store(in: &disposables)

        loadPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    self.appState = .ready
                case .failure( _):
                    self.appState = .error
                }},  receiveValue: { self.wordList.wordlist = $0})
            .store(in: &disposables)
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
        signalBreak = false
        matches.removeAll()
        for i in 1...5000{
            if (signalBreak) {
                break
            }
            passthrough.send("\(i)\(searchQuery)")
//            do {
//                usleep(500000)
//            }
        }
    }
    
    func clear() {
        matches.removeAll()
    }
    
    func lookupUrl(match : String) -> URLRequest {
        return URLRequest(url: URL(string: "https://www.google.com/search?q=define:\(match)")!)
    }
}
