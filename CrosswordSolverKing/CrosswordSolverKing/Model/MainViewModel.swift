//
//  MainViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 09/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import UIKit
import Combine

class MainViewModel : ObservableObject {
    @Published var menuLink : MenuViewLinks?

    private var disposables = Set<AnyCancellable>()
    
    init() {
        $menuLink
            .compactMap{$0}
            .sink(receiveValue: {self.menuPressed(item: $0)})
            .store(in: &disposables)

    }
    
    func menuPressed(item : MenuViewLinks){
        switch item {
        case .AboutLink:
            break
        case .HelpLink:
            break
        case .SettingsLink:
            showSettings()
        }
        
    }

    func showSettings(){
        let application = UIApplication.shared
        let url = URL(string: UIApplication.openSettingsURLString)! as URL
        if application.canOpenURL(url){
            application.open(url,options: [:],completionHandler: nil)
        }
    }
}
