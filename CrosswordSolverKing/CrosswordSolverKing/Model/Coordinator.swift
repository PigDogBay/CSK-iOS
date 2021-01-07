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

    //GADBannerVC will receive lots of change notifications, so only reload ad when
    //the orientation changes or user changes ad preference
    var isAdReloadRequired = false
    //Prevents ad reloads when the user resigns the app
    private var isActive = false
    //Reload the ad if the user reactivates the app in a different orientation
    private var isPortraitBeforeResign = true
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
        
        //Refresh the ad if the screen rotates has rotated. Ignore any changes when the app goes into the background
        $isPortrait
            .dropFirst()
            .filter{$0 != self.isPortrait && self.isActive}
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.isAdReloadRequired = true})
            .store(in: &disposables)
    }

    func showHelpExample(example : String){
        model.query = example
    }

    ///App life cycle function: called when the app goes into the background
    func onResignActive(){
        //Ignore orientation changes to prevent unnecessary ad updates
        isActive = false
        //Remember current orientation incase we need to reload the ad when the app becomes active again
        isPortraitBeforeResign = isPortrait
        model.stopSearch()
    }

    ///App life cycle function: called when the app becomes active again, eg user launches the app or presses back to CSK from system settings
    func onDidBecomeActive(){
        isActive = true
        if isPortraitBeforeResign != isPortrait && showSplash == false{
            //The user resigned the app and re-opened it in a different orientation
            //So need to reload the ad
            isAdReloadRequired = true
            self.objectWillChange.send()
        }
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
    
    func contextMenu(word : String, provider : DefinitionProviders){
        self.contextDefinitionWord = word
        self.contextDefinitionProvider = provider
        self.isDefinitionViewActive = true
    }
    
    private func adPreferencesChanged(value : Bool){
        settings.useNonPersonalizedAds = !value
        isAdReloadRequired = true
    }

    func createDefinitionViewModel() -> DefinitionModel {
        return ContextDefintion(word: contextDefinitionWord, provider: contextDefinitionProvider)
    }
}
