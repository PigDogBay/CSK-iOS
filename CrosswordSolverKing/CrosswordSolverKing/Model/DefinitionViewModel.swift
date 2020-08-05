//
//  DefinitionViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 11/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

enum DefinitionProviders {
    case Default,Collins, Dictionary, GoogleDefinition, Lexico, MerriamWebster, MWThesaurus, Thesaurus, Wiktionary, Wikipedia, WordGameDictionary
}

protocol DefinitionModel {
    var word : String { get }
    func lookupUrl() -> URLRequest
}

struct DefaultDefintion : DefinitionModel{
    let word : String
    
    func lookupUrl() -> URLRequest {
        let settings = Settings()
        let url = settings.getDefinitionUrl(word: word)
        return URLRequest(url: URL(string: url)!)
    }
}

struct ContextDefintion : DefinitionModel{
    let word : String
    let provider : DefinitionProviders
    
    func lookupUrl() -> URLRequest {
        let address = getAddress()
        return URLRequest(url: URL(string: address)!)
    }
    
    private func getAddress() -> String {
        switch provider {
        case .Default:
            return WordSearch.getGoogleUrl(word: word)
        case .Collins:
            return WordSearch.getCollinsUrl(word: word)
        case .Dictionary:
            return WordSearch.getDictionaryComUrl(word: word)
        case .GoogleDefinition:
            return WordSearch.getGoogleDefineUrl(word: word)
        case .Lexico:
            return WordSearch.getLexicoUrl(word: word)
        case .MerriamWebster:
            return WordSearch.getMerriamWebsterUrl(word: word)
        case .MWThesaurus:
            return WordSearch.getMWThesaurusUrl(word: word)
        case .Thesaurus:
            return WordSearch.getThesaurusComUrl(word: word)
        case .Wiktionary:
            return WordSearch.getWiktionaryUrl(word: word)
        case .Wikipedia:
            return WordSearch.getWikipediaUrl(word: word)
        case .WordGameDictionary:
            return WordSearch.getWordGameDictionaryUrl(word: word)
        }
    }
}

