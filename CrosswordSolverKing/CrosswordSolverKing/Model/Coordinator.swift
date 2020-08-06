//
//  Coordinator.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

enum AppScreens {
    case Splash, Main, About, Filter, Help
}

///Deals with interactions between views and holds shared observed variables
class Coordinator : ObservableObject {
    let model : Model
    let ratings : Ratings
    let settings : Settings

    @Published var showMeRelevantAds = true
    @Published var isAdReloadRequired = false
    @Published var isPortrait = true

    private var showMePressed = false
    private var showMeExample = ""

    ///Holds the current word list name, is used to check if a new word list needs to be loaded
    private var wordListName = ""


    init(){
        model = Model()
        ratings = Ratings(appId: Strings.appId)
        settings = Settings()
        showMeRelevantAds = !settings.useNonPersonalizedAds
    }

    func showHelpExample(example : String){
        showMePressed = true
        showMeExample = example
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

    func onAppear(screen : AppScreens){
        switch screen {
        case .Splash:
            splashEntered()
        case .Main:
            mainEntered()
        case .About:
            break
        case .Filter:
            break
        case .Help:
            break
        }
    }
    
    func onDisappear(screen : AppScreens){
        switch screen {
        case .Splash:
            break
        case .Main:
            break
        case .About:
            aboutExited()
        case .Filter:
            break
        case .Help:
            break
        }
    }
    
    private func aboutExited(){
        if settings.useNonPersonalizedAds == showMeRelevantAds {
            isAdReloadRequired = true
        }
        settings.useNonPersonalizedAds = !showMeRelevantAds
    }
    
    private func mainEntered(){
        if showMePressed {
            showMePressed = false
            model.query = showMeExample
        }
    }
    
    private func splashEntered(){
        if model.appState == .uninitialized {
            model.loadWordList(name: Settings().wordList)
        }
    }
}
