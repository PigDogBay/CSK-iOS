//
//  AutoTest.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 13/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import Combine
import SwiftUtils

/*
In SceneDelegate.swift call
 AutoTest.start(coordinator: coordinator)

 after window.makeKeyAndVisible()
 */
class AutoTest {
    private static var instance : AutoTest?
    private let model : Model
    private var disposables = Set<AnyCancellable>()
    private let randomQuery = RandomQuery()
    
    static func start(coordinator : Coordinator){
        if instance == nil {
            instance = AutoTest(model: coordinator.model)
            coordinator.model.reset()
        }
    }

    init(model : Model){
        self.model = model
        
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
            break
        case .ready:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.model.query = self.randomQuery.query()
            }
        case .searching:
            break
        case .finished:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.model.query = ""
                //self.loadRandomWordlist()
            }
        case .error:
            print("AutoTest: App Error Detected")
        }
    }
    
    /*
        Simulate the user changing the word list setting causing the app to restart and show the splash screen
     */
    private func loadRandomWordlist(){
        let wordListNames = ["words","wordlist-de","wordlist-es","wordlist-fr","wordlist-it","wordlist-pt","twl","sowpods"]
        if let wordList = wordListNames.randomElement(){
            model.query = ""
            model.matches.removeAll()
            model.filters.reset()
            //this will reset the app state to .uninitialized
            model.loadWordList(name: wordList)
        }
    }
}
