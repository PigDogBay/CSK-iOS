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

class MainViewModel : ObservableObject {
    private static let MAX_UPDATES = 60
    
    let model : Model
    private var disposables = Set<AnyCancellable>()
    private var contextDefinitionProvider : DefinitionProviders = .Default
    private var contextDefinitionWord = "crossword"

    @Published var showTips = true
    @Published var topLeftButton = ""
    @Published var isDefinitionViewActive = false

    init(model : Model){
        self.model = model
        showTips = model.appState == .ready
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
