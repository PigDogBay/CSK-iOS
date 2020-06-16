//
//  Model.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Combine
import Foundation

class Model : ObservableObject {
    private let crosswordMatches = ["magee","mages","maggs","magic","magma","magog","magoo","magot","magus","mcgee","megan","miggs","might"]

    enum AppStates {
        case ready,searching,finished
    }
    
    @Published var query = ""
    @Published var matches : [String] = []
    @Published var appState = AppStates.ready
    
    private let scheduler = DispatchQueue.global(qos: .background)
    private var disposables = Set<AnyCancellable>()
    private let passthrough = PassthroughSubject<String,Never>()
    private var signalBreak = false
    
    let filters = Filters()

    init(){
        passthrough
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {self.matches.append($0)})
            .store(in: &disposables)

        $query
            .dropFirst(1)
            .handleEvents(receiveOutput: {_ in self.signalBreak = true})
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .filter{$0 == self.query} //ignore any intermediate searches
            .sink(receiveValue: {self.search(searchQuery: $0)})
            .store(in: &disposables)
        
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
