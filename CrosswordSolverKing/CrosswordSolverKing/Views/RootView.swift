//
//  RootView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 07/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator : Coordinator
    
    @ViewBuilder
    var body: some View {
        if coordinator.showSplash {
            SplashScreen()
        } else {
            MainView(coordinator: coordinator)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
