//
//  MainViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine
import SwiftUtils

///Need to delay orientation changes if the view is not visible so that the ad banner can reload if necessary
enum OrientationChangeStates {
    case NoChange, ChangeToPortrait, ChangeToLandscape
}

class MainViewModel : ObservableObject {
    private static let MAX_UPDATES = 60
    
    let model : Model
    private var disposables = Set<AnyCancellable>()
    private var isShowing = false
    private var orientationState : OrientationChangeStates = .NoChange
    private var contextDefinitionProvider : DefinitionProviders = .Default
    private var contextDefinitionWord = "crossword"

    @Published var showTips = true
    @Published var topLeftButton = ""
    @Published var isPortrait = true
    @Published var isDefinitionViewActive = false

    init(coordinator : Coordinator){
        self.model = coordinator.model
        showTips = model.appState == .ready
        isPortrait = coordinator.isPortrait
        topLeftButton = getTopLeftButtonText(appState: model.appState)
        
        model.$appState
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{appState in self.showTips = self.model.appState == .ready})
            .store(in: &disposables)
        
        model.$appState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.topLeftButton = self.getTopLeftButtonText(appState: value)})
            .store(in: &disposables)
        
        //The view does not observe changes in the model, so need to listen for new matches
        //and send update notifications so that the view can show matches as they are found.
        model.$matches
            .receive(on: DispatchQueue.main)
            .filter{_ in self.model.appState == .searching && self.model.matches.count < MainViewModel.MAX_UPDATES}
            .sink(receiveValue: {_ in self.objectWillChange.send()})
            .store(in: &disposables)
        
        coordinator.$isPortrait
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in self.onOrientationChange(isPortrait: value)})
            .store(in: &disposables)

    }
    
    ///Called when the NavigationView disappears the main view
    ///Notes it is NOT called when the app goes into the background
    func onDisappear(){
        isShowing = false
    }
    
    ///Called when the NavigationView shows the main view
    ///Note it is NOT called when the app becomes active from the background
    func onAppear(){
        isShowing = true
        applyOrientationChanges()
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
    
    private func getTopLeftButtonText(appState : AppStates) -> String {
        if appState == .searching {
            return "Stop"
        } else {
            return "Reset"
        }
    }
}
