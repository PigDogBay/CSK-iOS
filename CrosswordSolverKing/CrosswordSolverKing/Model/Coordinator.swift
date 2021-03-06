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
    let ads : Ads

    @Published var showMeRelevantAds = true
    @Published var isPortrait = true
    @Published var showSplash = true
    @Published var isDefinitionViewActive = false
    @Published var showAd = false

    //GADBannerVC will receive lots of change notifications, so only reload ad when
    //the orientation changes, multi-pane resize or user changes ad preference
    private var isAdReloadRequired = false
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
        ads = Ads()
        
        //ATT Request dialog shows on the queue default-qos
        //Need to ensure showAd is set on queue main-thread
        ads.$isAdsSetupFinished
            .filter{$0}
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{_ in self.showAd = true})
            .store(in: &disposables)

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
        
        //Refresh the ad if the screen has rotated. Ignore any changes when the app goes into the background
        $isPortrait
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.isAdReloadRequired = true})
            .store(in: &disposables)
    }

    func showHelpExample(example : String){
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
        ads.requestIDFA()
        if model.appState == .uninitialized {
            model.loadWordList(name: Settings().wordList)
        }
    }
    
    func filterExited(){
        model.search(searchQuery: model.query)
    }
    
    func lookUpWord(word : String){
        let defModel = DefaultDefintion(word: word)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }
    
    func lookUpWord(word : String, provider : DefinitionProviders){
        let defModel = ContextDefintion(word : word, provider: provider)
        if let url = defModel.lookupUrl(){
            showWebPage(address: url)
        }
    }
    
    private func adPreferencesChanged(value : Bool){
        settings.useNonPersonalizedAds = !value
        isAdReloadRequired = true
    }
    
    /*
     This function will clear the ad reload flag
     */
    func checkAdReloadRequired() -> Bool {
        let tmp = isAdReloadRequired
        isAdReloadRequired = false
        return tmp
    }

    func showWebPage(address : String) {
        if let url = URL(string: address) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
