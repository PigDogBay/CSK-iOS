//
//  DefinitionViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 11/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation

struct DefinitionViewModel {
    let word : String
    
    func lookupUrl() -> URLRequest {
        let settings = Settings()
        let url = settings.getDefinitionUrl(word: word)
        return URLRequest(url: URL(string: url)!)
    }
}
