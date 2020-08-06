//
//  MainViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine

enum MainScreens {
    case Splash, Tips, Matches
}

///Need to delay orientation changes if the view is not visible so that the ad banner can reload if necessary
enum OrientationChangeStates {
    case NoChange, ChangeToPortrait, ChangeToLandscape
}

class MainViewModel : ObservableObject {
    private static let MAX_UPDATES = 60
    
    let model : Model
    private var disposables = Set<AnyCancellable>()
    private var isShowing = true
    private var orientationState : OrientationChangeStates = .NoChange
    private var contextDefinitionProvider : DefinitionProviders = .Default
    private var contextDefinitionWord = "crossword"

    @Published var screen : MainScreens = .Splash
    @Published var topLeftButton = ""
    @Published var isPortrait = true
    @Published var isDefinitionViewActive = false
    
    init(){
        self.model = Model()
        
        //The screen state needs to update when appState changes or when query changes from an empty string. So to merge the publishers
        //I will need to transform them to publishers that return the same type.
        let appStatePublisher = model.$appState
            .map { appState -> MainScreens in self.getMainScreen(appState: appState, query: self.model.query)}
        
        model.$query
            .map { query -> MainScreens in self.getMainScreen(appState: self.model.appState, query: query)}
            .merge(with: appStatePublisher)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{screen in self.screen = screen})
            .store(in: &disposables)
        
        model.$appState
            .receive(on: DispatchQueue.main)
            .map{appState -> String in
                if appState == .searching {
                    return "Stop"
                } else {
                    return "Reset"
                }}
            .sink(receiveValue: {value in self.topLeftButton = value})
            .store(in: &disposables)
        
        //The view does not observe changes in the model, so need to listen for new matches
        //and send update notifications so that the view can show matches as they are found.
        model.$matches
            .receive(on: DispatchQueue.main)
            .filter{_ in self.model.appState == .searching && self.model.matches.count < MainViewModel.MAX_UPDATES}
            .sink(receiveValue: {_ in self.objectWillChange.send()})
            .store(in: &disposables)
    }
    
    func onDisappear(){
        isShowing = false
        model.stopSearch()
    }
    
    func onAppear(){
        isShowing = true
        //May have appeared from the filter screen, so apply any filters
        model.applyFilters()
        applyOrientationChanges()
    }
    
    func splashScreenAppeared(){
        if model.appState == .uninitialized {
            model.loadWordList(name: Settings().wordList)
        }
    }
    
    ///Ad banner will need reloading if the orientation changed when the view was not showing
    private func applyOrientationChanges(){
        switch orientationState {
        case .NoChange:
            break
        case .ChangeToPortrait:
            isPortrait = true
        case .ChangeToLandscape:
            isPortrait = false
        }
        orientationState = .NoChange

    }
    
    ///Will need to delay orientation changes if the view is not showing
    /// - Parameter isPortrait: true if current orientation is portrait
    func onOrientationChange(isPortrait : Bool){
        if isShowing {
            orientationState = .NoChange
            self.isPortrait = isPortrait
        } else {
            orientationState = isPortrait ? .ChangeToPortrait : .ChangeToLandscape
        }
    }

    
    ///Main screen is determined by `app state` and `query`
    /// - parameter appState: current state of the model
    /// - parameter query: search query
    private func getMainScreen(appState : AppStates, query : String) -> MainScreens {
        if appState == .uninitialized {
            return .Splash
        } else if query == "" {
            return .Tips
        }
        return .Matches
    }

    func getStatusText() -> String{
        switch model.appState {
        case .uninitialized:
            return "Loading"
        case .ready:
            return ""
        case .searching:
            if model.filters.filterCount > 1 {
                return "Searching (\(model.filters.filterCount) Filters Active)"
            }
            if model.filters.filterCount > 0 {
                return "Searching (\(model.filters.filterCount) Filter Active)"
            }
            return "Searching"
        case .finished:
            if model.query == "" {
                return ""
            }
            if model.filters.filterCount > 0 {
                return "Matches: \(model.matches.count) Filters: \(model.filters.filterCount)"
            }
            return "Matches: \(model.matches.count)"
        case .error:
            return "Restart the app"
        }
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
