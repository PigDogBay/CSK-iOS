//
//  RootView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 07/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct RootView: View {
    @EnvironmentObject var coordinator : Coordinator

    private func adSection() -> some View {
        HStack {
            let size = GADBannerViewController.getAdBannerSize()
            Spacer()
            GADBannerViewController()
                .frame(width: size.size.width, height: size.size.height)
            Spacer()
        }
    }
    
    private var contentSection : some View {
        VStack(){
            NavigationView {
                MainView(model: self.coordinator.model)
                    .onDisappear(perform: self.coordinator.mainExited)
                    .onAppear(perform: self.coordinator.mainEntered)
            }.navigationViewStyle(StackNavigationViewStyle())
            if coordinator.showAd{
                adSection()
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        if coordinator.showSplash {
            SplashScreen()
                .onAppear(perform: coordinator.splashEntered)
        } else {
            contentSection
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
