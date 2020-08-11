//
//  MainViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import Combine

class MainViewModel : ObservableObject {
    
    let model : Model
    private var disposables = Set<AnyCancellable>()

    @Published var showTips = true
    @Published var topLeftButton = ""
    @Published var status = ""

    init(model : Model){
        self.model = model
        onAppState(newState: model.appState)
        
        model.$appState
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{[weak self] appState in self?.onAppState(newState: appState)})
            .store(in: &disposables)
    }
    
    private func onAppState(newState : AppStates){
        switch newState {
        case .uninitialized:
            topLeftButton = ""
            showTips = true
            status = ""
        case .ready:
            topLeftButton = ""
            showTips = true
            status = ""
        case .searching:
            topLeftButton = "Stop"
            showTips = false
            status = getSearchingStatusText()
        case .finished:
            topLeftButton = "Reset"
            showTips = false
            status = getFinishedStatusText()
        case .error:
            topLeftButton = ""
            showTips = false
            status = "Restart the app"
        }
    }
    
    private func getSearchingStatusText() -> String{
        if model.filters.filterCount > 1 {
            return "Searching (\(model.filters.filterCount) Filters Active)"
        }
        if model.filters.filterCount > 0 {
            return "Searching (\(model.filters.filterCount) Filter Active)"
        }
        return "Searching"
    }
    
    private func getFinishedStatusText() -> String{
        if model.query == "" {
            return ""
        }
        if model.filters.filterCount > 0 {
            return "Matches: \(model.matches.count) Filters: \(model.filters.filterCount)"
        }
        return "Matches: \(model.matches.count)"
    }
}
