//
//  Coordinator.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils
import Combine

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {
    let model : Model
    let ratings : Ratings
    let settings : Settings

    @Published var showMeRelevantAds = true
    @Published var isPortrait = true
    @Published var showSplash = true
    @Published var isDefinitionViewActive = false

    var isAdReloadRequired = false
    private var contextDefinitionProvider : DefinitionProviders = .Default
    private var contextDefinitionWord = "crossword"
    private var disposables = Set<AnyCancellable>()

    ///Holds the current word list name, is used to check if a new word list needs to be loaded
    private var wordListName = ""


    init(){
        model = Model()
        ratings = Ratings(appId: Strings.appId)
        settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
        
        model.$appState
            .removeDuplicates()
            .map{$0 == .uninitialized}
            .filter{$0 != self.showSplash}
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.showSplash = value})
            .store(in: &disposables)
        
        //Refresh the ad if the user changes the ad prefence
        $showMeRelevantAds
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.adPreferencesChanged(value: value)})
            .store(in: &disposables)
    }

    func showHelpExample(example : String){
        model.reset()
        model.query = example
    }

    ///App life cycle function: called when the app goes into the background
    func onResignActive(){
        model.stopSearch()
    }

    ///App life cycle function: called when the app becomes active again, eg user launches the app or presses back to CSK from system settings
    func onDidBecomeActive(){
        if wordListName != "" {
            //check if need to change the word list
            if wordListName != Settings().wordList {
                model.appState = .uninitialized
                model.query = ""
                model.matches.removeAll()
                model.filters.reset()
            }
        }
        applySettings()
    }
    
    private func applySettings(){
        wordListName = settings.wordList
        model.wordFormatter.highlightColor = settings.highlight
        model.resultsLimit = settings.resultsLimit
        model.wordSearch.findSubAnagrams = settings.showSubAnagrams
    }

    func mainEntered(){
        //Good time to ask
        ratings.requestRating()
    }
    
    func mainExited(){
        model.stopSearch()
    }
    
    func splashEntered(){
        if model.appState == .uninitialized {
            model.loadWordList(name: Settings().wordList)
        }
    }
    
    func filterExited(){
        model.search(searchQuery: model.query)
    }
    
    private func adPreferencesChanged(value : Bool){
        settings.useNonPersonalizedAds = !value
        isAdReloadRequired = true
    }
    
    func contextMenu(word : String, provider : DefinitionProviders){
        self.contextDefinitionWord = word
        self.contextDefinitionProvider = provider
        self.isDefinitionViewActive = true
    }
    
    func createDefinitionViewModel() -> DefinitionModel {
        return ContextDefintion(word: contextDefinitionWord, provider: contextDefinitionProvider)
    }
}
