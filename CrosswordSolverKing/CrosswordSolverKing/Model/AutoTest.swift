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

class AutoTest {
    private let model : Model
    private var disposables = Set<AnyCancellable>()
    private let randomQuery = RandomQuery()

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
        print("AutoState \(newState)")
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
            }
        case .error:
            print("AutoTest: App Error Detected")
        }
    }
}
