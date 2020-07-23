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

class MainViewModel : ObservableObject {
    let model : Model
    private var disposables = Set<AnyCancellable>()

    @Published var screen : MainScreens = .Splash
    
    init(model : Model){
        self.model = model
        
        model.$appState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:
                {   appState in
                    if appState == .uninitialized {
                        self.screen = .Splash
                    } else if self.model.query == "" {
                        self.screen = .Tips
                    } else {
                        self.screen = .Matches
                    }
                })
        .store(in: &disposables)
        
        model.$query
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:
                {   query in
                    if self.model.appState == .uninitialized {
                        self.screen = .Splash
                    } else if self.model.query == "" {
                        self.screen = .Tips
                    } else {
                        self.screen = .Matches
                    }
                })
        .store(in: &disposables)

        //TODO: - remove - just debug
        $screen
            .sink(receiveValue: {print("\($0)")})
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
}
