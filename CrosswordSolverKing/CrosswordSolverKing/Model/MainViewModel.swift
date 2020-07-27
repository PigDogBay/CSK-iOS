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
    private static let MAX_UPDATES = 60
    
    let model : Model
    private var disposables = Set<AnyCancellable>()

    @Published var screen : MainScreens = .Splash
    @Published var topLeftButton = ""
    
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
        model.stopSearch()
    }
    
    func onAppear(){
    }
    
    /*
        Main screen is determined by app state and query
     */
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
    
    func format(match : String) -> String {
        return model.wordFormatter.format(match)
    }

    //Replaced spaces/full stops with a question mark
    func setQueryFrom(typed : String) {
        model.query = typed.replacingOccurrences(of: " ", with: "?").replacingOccurrences(of: ".", with: "?")
        //Notify view that the query has changed
        self.objectWillChange.send()
    }
    
    func setQueryFrom(tip : String){
        model.query = tip
    }
}
