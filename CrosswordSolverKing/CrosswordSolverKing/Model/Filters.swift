//
//  Filters.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Combine
import Foundation
import SwiftUtils

class Filters : ObservableObject {
    @Published var contains = ""
    @Published var excludes = ""
    @Published var containsWord = ""
    @Published var excludesWord = ""
    @Published var prefix = ""
    @Published var suffix = ""
    @Published var pattern = ""
    @Published var regExp = ""
    @Published var distinctSelection = 0
    @Published var lessThan = 0
    @Published var moreThan = 0
    @Published var equalTo = 0
    
    var isSearchRequired = false

    var filterCount : Int {
        var count = 0
        if moreThan != 0 { count = count + 1}
        if lessThan != 0 { count = count + 1}
        if equalTo != 0 { count = count + 1}
        if distinctSelection != 0 { count = count + 1}
        if prefix != "" { count = count + 1}
        if suffix != "" { count = count + 1}
        if contains != "" { count = count + 1}
        if excludes != "" { count = count + 1}
        if containsWord != "" { count = count + 1}
        if excludesWord != "" { count = count + 1}
        if pattern != "" { count = count + 1}
        if regExp != "" { count = count + 1}
        return count
    }
    
    func viewAppear(){
        //Always perform a new search when the filters have been shown
        isSearchRequired = true
    }
    
    func reset() {
        moreThan = 0
        lessThan = 0
        equalTo = 0
        distinctSelection = 0
        prefix = ""
        suffix = ""
        contains = ""
        excludes = ""
        containsWord = ""
        excludesWord = ""
        pattern = ""
        regExp = ""
    }

    func createChainedCallback(lastCallback: WordListCallback) -> WordListCallback {
        var callback = lastCallback
        
        //chain filters
        if self.equalTo != 0 {
            callback = EqualToFilter(callback: callback, size: self.equalTo)
        }
        if self.lessThan != 0 {
            callback = LessThanFilter(callback: callback, size: self.lessThan)
        }
        if self.moreThan != 0 {
            callback = BiggerThanFilter(callback: callback, size: self.moreThan)
        }
        if self.prefix != "" {
            callback = StartsWithFilter(callback: callback, letters: self.prefix)
        }
        if self.suffix != "" {
            callback = EndsWithFilter(callback: callback, letters: self.suffix)
        }
        if self.contains != "" {
            callback = ContainsFilter(callback: callback, letters: self.contains)
        }
        if self.excludes != "" {
            callback = ExcludesFilter(callback: callback, letters: self.excludes)
        }
        if self.containsWord != "" {
            callback = ContainsWordFilter(callback: callback, word: self.containsWord)
        }
        if self.excludesWord != "" {
            callback = ExcludesWordFilter(callback: callback, word: self.excludesWord)
        }
        if self.pattern != "" {
            callback =  RegexFilter.createCrosswordFilter(callback: callback, query: self.pattern)
        }
        if self.regExp != "" {
            callback =  RegexFilter(callback: callback, pattern: self.regExp)
        }
        if self.distinctSelection == 1 {
            callback = DistinctFilter(callback: callback)
        }
        if self.distinctSelection == 2 {
            callback = NotDistinctFilter(callback: callback)
        }
        return callback
    }
}
